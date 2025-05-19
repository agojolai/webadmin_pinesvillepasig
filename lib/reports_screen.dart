import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'menu.dart';

final ValueNotifier<String> selectedFilterStatusNotifier = ValueNotifier<String>('All');
const Map<String, String?> statusFilterMap = {
  'All': null,
  'Completed': 'completed',
  'On Progress': 'on progress',
};

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  String formatTimestamp(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } else if (value is String) {
      try {
        final date = DateTime.parse(value);
        return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      } catch (e) {
        return 'Invalid Date';
      }
    }
    return 'N/A';
  }

  String getFirstSentence(String text) {
    final sentenceEnd = text.indexOf(RegExp(r'[.!?]'));
    if (sentenceEnd != -1) {
      return text.substring(0, sentenceEnd + 1).trim();
    }
    return text; // If no punctuation, return the whole string
  }


  @override
  Widget build(BuildContext context) {
    //String selectedFilterStatus = 'All';
    final textStyle = TextStyle(color: Colors.white, fontSize: 14);
    final columnTitles = ["Unit No.", "Type", "Report Date", "Description", "Status"];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          SidebarMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pages / Reports',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[400])),
                  const SizedBox(height: 0),
                  Text('Reports',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),



                  Align(
                    alignment: Alignment.centerLeft,
                    child: ValueListenableBuilder(
                        valueListenable: selectedFilterStatusNotifier,
                        builder: (context, selectedFilterDisplay, _) {
                          return DropdownButton<String>(
                            value: selectedFilterDisplay,
                            dropdownColor: Colors.grey[850],
                            style: const TextStyle(color: Colors.white),
                            items: statusFilterMap.keys.map((status) {
                              return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status)
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                selectedFilterStatusNotifier.value = newValue;
                              }
                            },
                          );
                        }),
                  ),

                  const SizedBox(height: 20),

                  // Table header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
                      color: const Color(0xFF1E1E1E),
                    ),
                    child: Row(
                      children: columnTitles.map((title) {
                        return Expanded(
                          flex: title == "Description" ? 3 : 2,
                          child: Text(title, style: textStyle.copyWith(fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  ),

                  Expanded(
                      child: ValueListenableBuilder<String>(
                        valueListenable: selectedFilterStatusNotifier,
                        builder: (context, selectedFilterStatus, _) {
                          Query<Map<String, dynamic>> baseQuery = FirebaseFirestore.instance
                          .collection('Reports')
                          .orderBy('ReportDate', descending: true);

                          if (selectedFilterStatus != 'All') {
                            baseQuery = baseQuery.where('status', isEqualTo: selectedFilterStatus);
                          }

                          return StreamBuilder<QuerySnapshot>(
                            stream: baseQuery.snapshots(),
                            builder: (context, snapshot) {


                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if(!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Center(child: Text('No reports found', style: TextStyle(color: Colors.white)));
                              }

                              final reports = snapshot.data!.docs;

                              return ListView.builder(

                                itemCount: reports.length,
                                itemBuilder: (context, index) {

                                  final reportDoc = reports[index];
                                  var data = reportDoc.data() as Map<String, dynamic>;
                                  final unitNo = data['UnitNo'] ?? 'N/A';
                                  final category = data['Category'] ?? 'N/A';
                                  final status = data['status'] ?? 'On Progress'; // Fallback if null

                                  final rawStatus = data['status'] ?? '';
                                  String selectedStatus = [' ', 'Completed', 'On Progress'].contains(rawStatus) ? rawStatus : ' ';


                                  final reportDate = formatTimestamp(data['ReportDate']);
                                  final rawDesc = data['ReportDesc'] ?? 'No Description';
                                  final reportDesc = getFirstSentence(rawDesc);

                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              backgroundColor: Colors.grey[900],
                                              /* title: const Text ('Report Details',
                                            style: TextStyle(
                                                color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40,
                                            )),*/
                                              content: SizedBox(
                                                width: 974,
                                                height: 546,
                                                child: Padding(
                                                    padding: const EdgeInsets.all(24.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const Text('Report Details',
                                                                style: TextStyle(
                                                                  fontSize: 40,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                ),
                                                              ),

                                                              const SizedBox(height: 30),

                                                              detailRow('Unit No:', unitNo),
                                                              detailRow('Type:', category),
                                                              detailRow('Report Date: ', reportDate),
                                                              detailRow('Description', rawDesc, isMultiLine: true),
                                                              detailRow('Status', '$status') //TBI to replace
                                                            ],
                                                          ),
                                                        ),

                                                        const SizedBox(width: 30),


                                                        Expanded(
                                                            flex: 1,
                                                            child: StatefulBuilder(
                                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              builder: (context, setState) {
                                                                return Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            //TODO
                                                                          },
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: const Color(0xFF2C2C2C),
                                                                              borderRadius: BorderRadius.circular(12),
                                                                            ),
                                                                            child: const Center(
                                                                              child: Text('Click to view image /\nNo Image',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(color: Colors.white70),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )),

                                                                    const SizedBox(height: 20),

                                                                    //Drop Down Button
                                                                    SizedBox(
                                                                      width: double.infinity,
                                                                      child: DropdownButtonFormField<String> (
                                                                        value: selectedStatus,
                                                                        dropdownColor: Colors.grey[850],
                                                                        decoration: InputDecoration(
                                                                          filled: true,
                                                                          fillColor: const Color(0xFF2C2C2C),
                                                                          border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            borderSide: BorderSide.none,
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                                        ),
                                                                        items: [' ', 'Completed', 'On Progress'].map((status) {
                                                                          return DropdownMenuItem(
                                                                            value: status,
                                                                            child: Text(
                                                                                status.isEmpty ? 'Selected Status' : status,
                                                                                style: const TextStyle(color: Colors.white)),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged: (value) {
                                                                          if (value == null) return;
                                                                          selectedStatus = value;
                                                                          FirebaseFirestore.instance
                                                                              .collection('Reports')
                                                                              .doc(reportDoc.id)
                                                                              .update({'status' : selectedStatus});
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                );
                                                              },
                                                            )
                                                        )

                                                      ],
                                                    )
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                                                ),
                                              ],

                                            );
                                          }
                                      );
                                    },

                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        //color: Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(unitNo, style: const TextStyle(color: Colors.white)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(category, style: const TextStyle(color: Colors.white)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(reportDate, style: const TextStyle(color: Colors.white)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(reportDesc, style: const TextStyle(color: Colors.white)),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return DropdownButton<String> (
                                                      isExpanded: true,
                                                      value: selectedStatus.isEmpty ? null : selectedStatus,
                                                      hint: const Text(''),
                                                      dropdownColor: Colors.grey[850],
                                                      style: const TextStyle(color: Colors.white),
                                                      items: <String>[' ', 'Completed', 'On Progress'].map((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedStatus = value!;
                                                        });

                                                        //update the status into firebase
                                                        FirebaseFirestore.instance
                                                            .collection('Reports')
                                                            .doc(reportDoc.id)
                                                            .update({'status' : selectedStatus});
                                                      },
                                                    );
                                                  }
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


Widget detailRow(String label, String value, {bool isMultiLine = false}) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
    child: Row(
      crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
            style: const TextStyle(color: Colors.grey,
            fontWeight: FontWeight.w600),
          ),
        ),

        //const SizedBox(width: 1),

        Expanded(child: Text(value,
            style: const TextStyle(color: Colors.white),
            softWrap: true))
      ],
    ),
  );
}

