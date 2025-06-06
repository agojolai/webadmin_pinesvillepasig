import 'package:flutter/material.dart';
import 'menu.dart'; // Your SidebarMenu
import 'create_billing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'utils/popups/loaders.dart';
import 'package:get/get.dart';

// Add this controller class at the top of the file
class SummaryController extends GetxController {
  final summaryData = {
    'totalCollected': 0.0,
    'totalRemaining': 0.0,
    'paidTenants': 0,
    'pendingTenants': 0,
    'totalTenants': 0,
  }.obs;

  final isLoading = true.obs;
  final lastFetchTime = Rxn<DateTime>();

  Future<void> fetchSummaryData() async {
    // Check if data was fetched in the last 5 minutes
    if (lastFetchTime.value != null &&
        DateTime.now().difference(lastFetchTime.value!).inMinutes < 5) {
      return; // Use cached data
    }

    isLoading.value = true;
    try {
      final now = DateTime.now();
      final monthYear = DateFormat('yyyy-MM').format(now);
      double totalCollected = 0.0;
      double totalRemaining = 0.0;
      int paidTenants = 0;
      int pendingTenants = 0;

      // Get all users with units in a single query
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('UnitNo', isNotEqualTo: '')
          .get();

      final totalTenants = usersSnapshot.docs.length;

      // Get all transactions for the current month
      final transactions = <DocumentSnapshot>[];
      for (final userDoc in usersSnapshot.docs) {
        final transactionDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userDoc.id)
            .collection('Transactions')
            .doc(monthYear)
            .get();
        if (transactionDoc.exists) {
          transactions.add(transactionDoc);
        }
      }

      // Process all transactions
      for (final transaction in transactions) {
        final transactionData = transaction.data() as Map<String, dynamic>;
        final status = transactionData['status'] as String? ?? 'unpaid';
        final amount = transactionData['totalAmount'] as num? ?? 0.0;

        if (status == 'paid') {
          totalCollected += amount.toDouble();
          paidTenants++;
        } else {
          totalRemaining += amount.toDouble();
          pendingTenants++;
        }
      }

      // Update the summary data
      summaryData.value = {
        'totalCollected': totalCollected,
        'totalRemaining': totalRemaining,
        'paidTenants': paidTenants,
        'pendingTenants': pendingTenants,
        'totalTenants': totalTenants,
      };

      lastFetchTime.value = DateTime.now();
    } catch (e) {
      print('Error fetching summary data: $e');
      PLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch summary data',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    lastFetchTime.value = null; // Force refresh
    fetchSummaryData();
  }
}

class BillsPaymentsScreen extends StatefulWidget {
  const BillsPaymentsScreen({super.key});

  @override
  State<BillsPaymentsScreen> createState() => _BillsPaymentsScreenState();
}

class _BillsPaymentsScreenState extends State<BillsPaymentsScreen> {
  int selectedTabIndex = 0;
  final List<String> tabs = ["Billings", "Payments", "Payment Validation"];
  final SummaryController summaryController = Get.put(SummaryController());

  @override
  void initState() {
    super.initState();
    summaryController.fetchSummaryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          SidebarMenu(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pages / Bills & Payments',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[400],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bills & Payments',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 30),

                  // Summary Cards
                  Obx(() {
                    if (summaryController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final summaryData = summaryController.summaryData.value;
                    return Wrap(
                      spacing: 120,
                      runSpacing: 16,
                      children: [
                        _buildSummaryCard(
                          "Total Rent Collected",
                          "₱${summaryData['totalCollected']?.toStringAsFixed(2) ?? '0.00'}",
                          Icons.payments,
                        ),
                        _buildSummaryCard(
                          "Total Rent Remaining",
                          "₱${summaryData['totalRemaining']?.toStringAsFixed(2) ?? '0.00'}",
                          Icons.money_off,
                        ),
                        _buildSummaryCard(
                          "Total Paid Tenants",
                          "${summaryData['paidTenants'] ?? 0}",
                          Icons.check_circle,
                        ),
                        _buildSummaryCard(
                          "Total Pending Tenants",
                          "${summaryData['pendingTenants'] ?? 0}",
                          Icons.warning_amber,
                        ),
                        _buildSummaryCard(
                          "Tenants",
                          "${summaryData['totalTenants'] ?? 0}",
                          Icons.group,
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 30),

                  // Card-style Tabs & Content
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0x00ff8049),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card-style Tab Buttons
                        Row(
                          children: List.generate(tabs.length, (index) {
                            final isSelected = selectedTabIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTabIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.orange
                                        : const Color(0xFF1E1E1E),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.orange
                                          : Colors.grey[700]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    tabs[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[300],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 20),

                        // Title and Search
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      tabs[selectedTabIndex],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    if (selectedTabIndex == 0) ...[
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.orange),
                                        onPressed: () =>
                                            CreateBilling.show(context),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Manage your tenants bills or modify their payments",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 300,
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                  filled: true,
                                  fillColor: Colors.grey[900],
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Tab Content
                        if (selectedTabIndex == 0) _buildBillingTable(),
                        if (selectedTabIndex == 1) _buildPaymentTable(),
                        if (selectedTabIndex == 2) _buildValidation(),

                        const SizedBox(height: 20),

                        // Action Buttons
                        if (selectedTabIndex == 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[800]),
                                child: const Text("Configure"),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[700]),
                                child: const Text("Edit"),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange),
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Summary Card Widget
  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Billing Table Widget
  Widget _buildBillingTable() {
    final columns = [
      "Unit",
      "Rent",
      "Electricity",
      "Trash Fee",
      "Wi-Fi",
      "Water",
      "Parking",
      "Extra",
      "Total",
    ];

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('units').snapshots(),
      builder: (context, unitsSnapshot) {
        if (unitsSnapshot.hasError) {
          return const Text('Error loading data',
              style: TextStyle(color: Colors.red));
        }

        if (unitsSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return FutureBuilder<List<DataRow>>(
          future: _getBillingData(unitsSnapshot.data!.docs),
          builder: (context, billingSnapshot) {
            if (billingSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final rows = billingSnapshot.data ?? [];

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.grey[900]!),
                columns: columns
                    .map((title) => DataColumn(
                          label: Text(
                            title,
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
                rows: rows,
              ),
            );
          },
        );
      },
    );
  }

  Future<List<DataRow>> _getBillingData(
      List<QueryDocumentSnapshot> unitDocs) async {
    final now = DateTime.now();
    final monthYear = DateFormat('yyyy-MM').format(now);
    final rows = <DataRow>[];

    for (final unitDoc in unitDocs) {
      final unitNumber = unitDoc['unitNumber'] as String?;
      if (unitNumber == null) continue;

      final billsSnapshot = await FirebaseFirestore.instance
          .collection('units')
          .doc(unitDoc.id)
          .collection('Bills')
          .doc(monthYear)
          .get();

      if (!billsSnapshot.exists) continue;

      final billData = billsSnapshot.data()!;
      final status = billData['status'] as String? ?? 'unpaid';
      final dueDate = billData['dueDate'] as String? ?? '';

      rows.add(DataRow(
        cells: [
          DataCell(
              Text(unitNumber, style: const TextStyle(color: Colors.white))),
          DataCell(Text(
              '₱${(billData['rentFee'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(
              '₱${(billData['electricityAmount'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(
              '₱${(billData['trashFee'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(
              '₱${(billData['wifiFee'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(
              '₱${(billData['waterAmount'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(
              '₱${(billData['parkingFee'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(
              '₱${(billData['extraFee'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(
              '₱${(billData['totalAmount'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(color: Colors.white))),
        ],
      ));
    }

    return rows;
  }

  // Payment Table Widget
  Widget _buildPaymentTable() {
    final columns = [
      "Unit",
      "Name",
      "Amount",
      "Due Date",
      "Status",
      "Payment Date"
    ];

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('UnitNo',
              isNotEqualTo: '') // Only get users with a unit number
          .snapshots(),
      builder: (context, usersSnapshot) {
        if (usersSnapshot.hasError) {
          return const Text('Error loading data',
              style: TextStyle(color: Colors.red));
        }

        if (usersSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (usersSnapshot.data == null || usersSnapshot.data!.docs.isEmpty) {
          return const Text('No users found',
              style: TextStyle(color: Colors.white));
        }

        return FutureBuilder<List<DataRow>>(
          future: _getPaymentData(usersSnapshot.data!.docs),
          builder: (context, paymentSnapshot) {
            if (paymentSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (paymentSnapshot.hasError) {
              return Text('Error: ${paymentSnapshot.error}',
                  style: const TextStyle(color: Colors.red));
            }

            final rows = paymentSnapshot.data ?? [];

            if (rows.isEmpty) {
              return const Text('No payment data found for this month',
                  style: TextStyle(color: Colors.white));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.grey[900]!),
                columns: columns
                    .map((title) => DataColumn(
                          label: Text(
                            title,
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
                rows: rows,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildValidation() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('UnitNo', isNotEqualTo: '')
          .snapshots(),
      builder: (context, usersSnapshot) {
        if (usersSnapshot.hasError) {
          return const Text('Error loading data',
              style: TextStyle(color: Colors.red));
        }

        if (usersSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return FutureBuilder<List<Widget>>(
          future: _getValidationList(usersSnapshot.data!.docs),
          builder: (context, validationSnapshot) {
            if (validationSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = validationSnapshot.data ?? [];

            if (items.isEmpty) {
              return const Center(
                child: Text(
                  'No pending payments to validate',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Container(
              height: MediaQuery.of(context).size.height - 300,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 8,
                radius: const Radius.circular(4),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) => items[index],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Widget>> _getValidationList(
      List<QueryDocumentSnapshot> userDocs) async {
    final now = DateTime.now();
    final monthYear = DateFormat('yyyy-MM').format(now);
    final items = <Widget>[];

    print('Total users to check: ${userDocs.length}');

    for (final userDoc in userDocs) {
      final unitNumber = userDoc['UnitNo'] as String?;
      final firstName = userDoc['FirstName'] as String?;
      final lastName = userDoc['LastName'] as String?;

      if (unitNumber == null || firstName == null || lastName == null) {
        print(
            'Skipping user - missing required fields: UnitNo=$unitNumber, FirstName=$firstName, LastName=$lastName');
        continue;
      }

      final fullName = '$firstName $lastName';
      print('Checking user: $fullName (Unit $unitNumber)');

      try {
        final transactionSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userDoc.id)
            .collection('Transactions')
            .doc(monthYear)
            .get();

        if (!transactionSnapshot.exists) {
          print('No transaction found for $fullName in $monthYear');
          continue;
        }

        final transactionData = transactionSnapshot.data()!;
        final status = transactionData['status'] as String? ?? 'unpaid';
        final proofUrl = transactionData['proofOfPaymentUrl'] as String? ?? '';

        print('Transaction data for $fullName:');
        print('- Status: $status');
        print('- Proof URL: $proofUrl');

        // Only show items that have a proof of payment but are not yet validated
        if (proofUrl.isNotEmpty && status == 'unpaid') {
          print('Adding $fullName to validation list');
          final amount = transactionData['totalAmount'] as num? ?? 0.0;

          items.add(
            Card(
              color: const Color(0xFF1E1E1E),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  'Unit $unitNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '₱${amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () => _showValidationDialog(
                  context,
                  userDoc.id,
                  unitNumber,
                  fullName,
                  amount,
                  proofUrl,
                ),
              ),
            ),
          );
        } else {
          print('Skipping $fullName - conditions not met:');
          print('- Has proof URL: ${proofUrl.isNotEmpty}');
          print('- Status is unpaid: ${status == 'unpaid'}');
        }
      } catch (e) {
        print('Error fetching transaction data for user ${userDoc.id}: $e');
        continue;
      }
    }

    print('Total items in validation list: ${items.length}');
    return items;
  }

  void _showValidationDialog(
    BuildContext context,
    String userId,
    String unitNumber,
    String name,
    num amount,
    String proofUrl,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Validation',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Unit $unitNumber',
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                name,
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                '₱${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (proofUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    proofUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'Error loading image',
                        style: TextStyle(color: Colors.red),
                      );
                    },
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => _rejectPayment(context, userId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Reject'),
            ),
            ElevatedButton(
              onPressed: () => _validatePayment(context, userId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Validate'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _validatePayment(BuildContext context, String userId) async {
    try {
      final now = DateTime.now();
      final monthYear = DateFormat('yyyy-MM').format(now);
      final formattedDate = DateFormat('MM/dd/yyyy').format(now);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Transactions')
          .doc(monthYear)
          .update({
        'status': 'paid',
        'datePaid': formattedDate,
        'validated': true,
        'validationDate': Timestamp.now(),
      });

      // Refresh summary data after validation
      summaryController.refreshData();

      Navigator.of(context).pop();
      PLoaders.successSnackBar(
        title: 'Success',
        message: 'Payment validated successfully',
      );
    } catch (e) {
      PLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to validate payment: $e',
      );
    }
  }

  Future<void> _rejectPayment(BuildContext context, String userId) async {
    try {
      final now = DateTime.now();
      final monthYear = DateFormat('yyyy-MM').format(now);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Transactions')
          .doc(monthYear)
          .update({
        'status': 'rejected',
        'validated': false,
        'validationDate': Timestamp.now(),
      });

      // Refresh summary data after rejection
      summaryController.refreshData();

      Navigator.of(context).pop();
      PLoaders.successSnackBar(
        title: 'Success',
        message: 'Payment rejected',
      );
    } catch (e) {
      PLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to reject payment: $e',
      );
    }
  }

  Future<List<DataRow>> _getPaymentData(
      List<QueryDocumentSnapshot> userDocs) async {
    final now = DateTime.now();
    final monthYear = DateFormat('yyyy-MM').format(now);
    final rows = <DataRow>[];

    for (final userDoc in userDocs) {
      final unitNumber = userDoc['UnitNo'] as String?;
      final firstName = userDoc['FirstName'] as String?;
      final lastName = userDoc['LastName'] as String?;

      if (unitNumber == null || firstName == null || lastName == null) continue;

      final fullName = '$firstName $lastName';

      try {
        final transactionSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userDoc.id)
            .collection('Transactions')
            .doc(monthYear)
            .get();

        if (!transactionSnapshot.exists) continue;

        final transactionData = transactionSnapshot.data()!;
        final status = transactionData['status'] as String? ?? 'unpaid';
        final dueDate = transactionData['dueDate'] as String? ?? '';
        final paymentDate = transactionData['datePaid'] as String? ?? '';
        final amount = transactionData['totalAmount'] as num? ?? 0.0;

        rows.add(DataRow(
          cells: [
            DataCell(
                Text(unitNumber, style: const TextStyle(color: Colors.white))),
            DataCell(
                Text(fullName, style: const TextStyle(color: Colors.white))),
            DataCell(Text('₱${amount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white))),
            DataCell(
                Text(dueDate, style: const TextStyle(color: Colors.white))),
            DataCell(Text(
              status,
              style: TextStyle(
                color: status == 'paid' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            )),
            DataCell(Text(
              paymentDate.isEmpty ? 'Not paid yet' : paymentDate,
              style: TextStyle(
                color: paymentDate.isEmpty ? Colors.orange : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            )),
          ],
        ));
      } catch (e) {
        print('Error fetching transaction data for user ${userDoc.id}: $e');
        continue;
      }
    }

    // Sort rows by unit number
    rows.sort((a, b) {
      final unitA = (a.cells[0].child as Text).data ?? '';
      final unitB = (b.cells[0].child as Text).data ?? '';
      return unitA.compareTo(unitB);
    });

    return rows;
  }
}
