import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

final ValueNotifier<String> selectedFilterStatusNotifier =
ValueNotifier<String>('All');

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
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white, fontSize: 14);
    final columnTitles = ["Unit No.", "Type", "Report Date", "Description", "Status"];

    return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Row(
          children: [
            SidebarMenu(), // Your custom sidebar
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
                                ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ValueListenableBuilder<String>(
                            valueListenable: selectedFilterStatusNotifier,
                            builder: (context, filter, _) {
                              return DropdownButton<String>(
                                value: filter,
                                dropdownColor: Colors.grey[850],
                                style: const TextStyle(color: Colors.white),
                                items: statusFilterMap.keys
                                    .map((status) =>
                                    DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    )
                                )
                                    .toList(),
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    selectedFilterStatusNotifier.value = newValue;
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
                          ),
                          child: Row(
                            children: columnTitles.asMap().entries.map((entry) {
                              final index = entry.key;
                              final title = entry.value;
                              final flex = [2, 2, 2, 3, 2][index];
                              return Expanded(
                                  flex: flex,
                                  child: Text(
                                    title,
                                    style: textStyle.copyWith(fontWeight: FontWeight.bold),
                                  )
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                            child: ValueListenableBuilder<String>(
                              valueListenable: selectedFilterStatusNotifier,
                              builder: (context, filter, _) {
                                Query<Map<String, dynamic>> baseQuery = FirebaseFirestore.instance
                                    .collection('Reports')
                                    .orderBy('ReportDate', descending: true);

                                if (filter != 'All') {
                                  baseQuery = baseQuery.where('status',
                                      isEqualTo: statusFilterMap[filter]);
                                }

                                return StreamBuilder<QuerySnapshot>(
                                  stream: baseQuery.snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator()
                                      );
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return const Center(
                                          child: Text('No reports found',
                                              style: TextStyle(color: Colors.white)));
                                    }
                                    final reports = snapshot.data!.docs;

                                    return ListView.builder(
                                        itemCount: reports.length,
                                        itemBuilder: (context, index) {
                                          final report = reports[index].data()
                                          as Map<String, dynamic>;
                                          final unit = report['UnitNo'] ?? 'N/A';
                                          final category = report['Category'] ?? 'N/A';
                                          final reportDate = formatTimestamp(report['ReportDate']);
                                          final rawDesc = report['ReportDesc'] ?? '';
                                          final reportDesc = getFirstSentence(rawDesc);
                                          final photos = List<String>.from(report['ReportPhotos'] ?? []);

                                          return ReportTile(
                                            reportId: reports[index].id,
                                            unit: unit,
                                            category: category,
                                            reportDate: reportDate,
                                            reportDesc: reportDesc,
                                            rawDesc: rawDesc,
                                            photos: photos,
                                            initialStatus: report['status'] ?? '',
                                          );
                                        }
                                    );
                                  },
                                );
                              },
                            )
                        )
                      ],
                    )
                )
            )
          ],
        )
    );
  }
}

class ReportTile extends StatefulWidget {
  final String reportId;
  final String unit;
  final String category;
  final String reportDate;
  final String reportDesc;
  final String rawDesc;
  final List<String> photos;
  final String initialStatus;

  ReportTile({super.key,
    required this.reportId,
    required this.unit,
    required this.category,
    required this.reportDate,
    required this.reportDesc,
    required this.rawDesc,
    required this.photos,
    required this.initialStatus,
  });

  @override
  State<ReportTile> createState() => _ReportTileState();
}

class _ReportTileState extends State<ReportTile> {
  String selectedStatus = '' ;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
  }

  void updateStatus(String newStatus) {
    FirebaseFirestore.instance
        .collection('Reports')
        .doc(widget.reportId)
        .update({'status': newStatus}).then((_) {
      setState(() {
        selectedStatus = newStatus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => ReportDetailsDialog(
                reportId: widget.reportId,
                unit: widget.unit,
                category: widget.category,
                reportDate: widget.reportDate,
                rawDesc: widget.rawDesc,
                photos: widget.photos,
                initialStatus: selectedStatus,
              )
          );
        },
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(widget.unit, style: TextStyle(color: Colors.white))),
                Expanded(flex: 2, child: Text(widget.category, style: TextStyle(color: Colors.white))),
                Expanded(flex: 2, child: Text(widget.reportDate, style: TextStyle(color: Colors.white))),
                Expanded(flex: 3, child: Text(widget.reportDesc, style: TextStyle(color: Colors.white))),
                Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedStatus.isEmpty ? '' : selectedStatus,
                      hint: const Text('', style: TextStyle(color: Colors.white)),
                      dropdownColor: Colors.grey[850],
                      style: const TextStyle(color: Colors.white),
                      items: ['', 'Completed', 'On Progress'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.isEmpty ? 'Select...' : value),
                        );
                      }).toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null && newStatus.isNotEmpty) {
                          updateStatus(newStatus);
                        }
                      },
                    )
                )
              ],
            )
        )
    );
  }
}

class ReportDetailsDialog extends StatelessWidget {
  final String reportId;
  final String unit;
  final String category;
  final String reportDate;
  final String rawDesc;
  final List<String> photos;
  final String initialStatus;

  ReportDetailsDialog({super.key,
    required this.reportId,
    required this.unit,
    required this.category,
    required this.reportDate,
    required this.rawDesc,
    required this.photos,
    required this.initialStatus,
  });

  Widget detailRow(String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment:
        isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(width: 100, child: Text('$label', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          Expanded(child: Text(value, style: TextStyle(color: Colors.white), softWrap: true))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.grey[900],
        content: SizedBox(
            width: 974,
            height: 500,
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Report Details',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40)),
                            const SizedBox(height: 30),
                            detailRow('Unit No.:', unit),
                            detailRow('Type', category),
                            detailRow('Report Date', reportDate),
                            detailRow('Description', rawDesc, isMultiLine: true),
                            detailRow('Status', initialStatus),
                          ],
                        )
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                        flex: 1,
                        child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C2C2C),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: photos.isEmpty
                                ? Center(
                                child: Text('No Images Available',
                                    style: TextStyle(color: Colors.white70)))
                                : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    children: photos.map((photo) {
                                      return Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => Dialog(
                                                        backgroundColor: Colors.transparent,
                                                        child: Stack(
                                                          children: [
                                                            Image.network(photo, fit: BoxFit.contain),
                                                            Positioned(
                                                                top: 8,
                                                                right: 8,
                                                                child: IconButton(icon: Icon(Icons.close, color: Colors.white),
                                                                    onPressed: () => Navigator.of(context).pop()
                                                                )
                                                            )
                                                          ],
                                                        )
                                                    )
                                                );
                                              },
                                              child: Container(
                                                width: 200,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    image: DecorationImage(
                                                        image: NetworkImage(photo),
                                                        fit: BoxFit.cover)),
                                              )
                                          )
                                      );
                                    }).toList()
                                )
                            )
                        )
                    )
                  ],
                )
            )
        )
    );
  }
}
