import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'utils/popups/loaders.dart';

class BillingController extends GetxController {
  final electricityPrevious = TextEditingController();
  final electricityCurrent = TextEditingController();
  final waterPrevious = TextEditingController();
  final waterCurrent = TextEditingController();

  // Amount controllers
  final rentController = TextEditingController();
  final trashController = TextEditingController();
  final wifiController = TextEditingController();
  final parkingController = TextEditingController();
  final extraController = TextEditingController();

  // Selected unit
  String? selectedUnit;
  String? selectedTenantId;

  final electricityConsumption = 0.obs;
  final waterConsumption = 0.obs;

  // Rate settings
  final electricityRate = 0.0.obs;
  final waterRate = 0.0.obs;
  final wifiRate = 0.0.obs;
  final parkingRate = 0.0.obs;
  final trashRate = 0.0.obs;

  // Amount calculations
  final electricityAmount = 0.0.obs;
  final waterAmount = 0.0.obs;
  final wifiAmount = 0.0.obs;
  final parkingAmount = 0.0.obs;
  final trashAmount = 0.0.obs;
  final totalAmount = 0.0.obs;

  // Storage keys
  static const String _electricityRateKey = 'electricity_rate';
  static const String _waterRateKey = 'water_rate';
  static const String _wifiRateKey = 'wifi_rate';
  static const String _parkingRateKey = 'parking_rate';
  static const String _trashRateKey = 'trash_rate';

  @override
  void onInit() {
    super.onInit();
    // Load saved rates
    final storage = GetStorage();
    electricityRate.value = storage.read(_electricityRateKey) ?? 0.0;
    waterRate.value = storage.read(_waterRateKey) ?? 0.0;
    wifiRate.value = storage.read(_wifiRateKey) ?? 0.0;
    parkingRate.value = storage.read(_parkingRateKey) ?? 0.0;
    trashRate.value = storage.read(_trashRateKey) ?? 0.0;

    // Set initial values for amount fields
    wifiController.text = wifiRate.value.toString();
    parkingController.text = parkingRate.value.toString();
    trashController.text = trashRate.value.toString();

    // Add listeners to all amount controllers
    rentController.addListener(_calculateTotal);
    trashController.addListener(_calculateTotal);
    wifiController.addListener(_calculateTotal);
    parkingController.addListener(_calculateTotal);
    extraController.addListener(_calculateTotal);
  }

  void _calculateTotal() {
    double total = 0.0;

    // Add rent
    if (rentController.text.isNotEmpty) {
      total += double.tryParse(rentController.text) ?? 0.0;
    }

    // Add electricity amount
    total += electricityAmount.value;

    // Add water amount
    total += waterAmount.value;

    // Add trash amount
    if (trashController.text.isNotEmpty) {
      total += double.tryParse(trashController.text) ?? 0.0;
    } else {
      total += trashRate.value;
    }

    // Add wifi amount
    if (wifiController.text.isNotEmpty) {
      total += double.tryParse(wifiController.text) ?? 0.0;
    } else {
      total += wifiRate.value;
    }

    // Add parking amount
    if (parkingController.text.isNotEmpty) {
      total += double.tryParse(parkingController.text) ?? 0.0;
    } else {
      total += parkingRate.value;
    }

    // Add extra
    if (extraController.text.isNotEmpty) {
      total += double.tryParse(extraController.text) ?? 0.0;
    }

    totalAmount.value = total;
  }

  void calculateConsumption() {
    // Calculate electricity consumption
    if (electricityPrevious.text.isNotEmpty &&
        electricityCurrent.text.isNotEmpty) {
      electricityConsumption.value = int.parse(electricityCurrent.text) -
          int.parse(electricityPrevious.text);
      // Calculate amount
      electricityAmount.value =
          electricityConsumption.value * electricityRate.value;
      _calculateTotal();
    }

    // Calculate water consumption
    if (waterPrevious.text.isNotEmpty && waterCurrent.text.isNotEmpty) {
      waterConsumption.value =
          int.parse(waterCurrent.text) - int.parse(waterPrevious.text);
      // Calculate amount
      waterAmount.value = waterConsumption.value * waterRate.value;
      _calculateTotal();
    }
  }

  void updateRates(double electricity, double water, double wifi,
      double parking, double trash) {
    electricityRate.value = electricity;
    waterRate.value = water;
    wifiRate.value = wifi;
    parkingRate.value = parking;
    trashRate.value = trash;

    // Save rates to local storage
    final storage = GetStorage();
    storage.write(_electricityRateKey, electricity);
    storage.write(_waterRateKey, water);
    storage.write(_wifiRateKey, wifi);
    storage.write(_parkingRateKey, parking);
    storage.write(_trashRateKey, trash);

    // Update amount fields if they're empty
    if (wifiController.text.isEmpty) {
      wifiController.text = wifi.toString();
    }
    if (parkingController.text.isEmpty) {
      parkingController.text = parking.toString();
    }
    if (trashController.text.isEmpty) {
      trashController.text = trash.toString();
    }

    calculateConsumption(); // Recalculate amounts with new rates
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) return null;
    final amount = double.tryParse(value);
    if (amount == null) return 'Please enter a valid number';
    if (amount < 0) return 'Amount cannot be negative';
    return null;
  }

  String? validateReading(String? value) {
    if (value == null || value.isEmpty) return null;
    final reading = int.tryParse(value);
    if (reading == null) return 'Please enter a valid number';
    if (reading < 0) return 'Reading cannot be negative';
    return null;
  }

  Future<void> saveBilling() async {
    if (selectedUnit == null || selectedTenantId == null) {
      PLoaders.errorSnackBar(
        title: 'Error',
        message: 'Please select a unit',
      );
      return;
    }

    // Validate all amounts
    final rentError = validateAmount(rentController.text);
    final trashError = validateAmount(trashController.text);
    final wifiError = validateAmount(wifiController.text);
    final parkingError = validateAmount(parkingController.text);
    final extraError = validateAmount(extraController.text);
    final electricPrevError = validateReading(electricityPrevious.text);
    final electricCurrError = validateReading(electricityCurrent.text);
    final waterPrevError = validateReading(waterPrevious.text);
    final waterCurrError = validateReading(waterCurrent.text);

    if (rentError != null ||
        trashError != null ||
        wifiError != null ||
        parkingError != null ||
        extraError != null ||
        electricPrevError != null ||
        electricCurrError != null ||
        waterPrevError != null ||
        waterCurrError != null) {
      PLoaders.errorSnackBar(
        title: 'Validation Error',
        message: 'Please check all fields for errors',
      );
      return;
    }

    final now = DateTime.now();
    final monthYear = DateFormat('yyyy-MM').format(now);
    final dueDate = now.add(const Duration(days: 5));
    final dueDateFormatted = DateFormat('MM/dd/yyyy').format(dueDate);

    try {
      // First, find the correct unit document
      final unitQuery = await FirebaseFirestore.instance
          .collection('units')
          .where('unitNumber', isEqualTo: selectedUnit)
          .get();

      if (unitQuery.docs.isEmpty) {
        PLoaders.errorSnackBar(
          title: 'Error',
          message: 'Unit document not found',
        );
        return;
      }

      final unitDocId = unitQuery.docs.first.id;

      // Save to Readings subcollection
      await FirebaseFirestore.instance
          .collection('units')
          .doc(unitDocId)
          .collection('Readings')
          .doc(monthYear)
          .set({
        'month': DateFormat('MMMM yyyy').format(now),
        'dateRecorded': Timestamp.now(),
        'electricPrevious': int.parse(electricityPrevious.text),
        'electricCurrent': int.parse(electricityCurrent.text),
        'electricConsumed': electricityConsumption.value,
        'electricAmount': electricityAmount.value,
        'waterPrevious': int.parse(waterPrevious.text),
        'waterCurrent': int.parse(waterCurrent.text),
        'waterConsumed': waterConsumption.value,
        'waterAmount': waterAmount.value,
      });

      // Save to Bills subcollection
      await FirebaseFirestore.instance
          .collection('units')
          .doc(unitDocId)
          .collection('Bills')
          .doc(monthYear)
          .set({
        'tenantId': selectedTenantId,
        'electricityUsed': electricityConsumption.value,
        'electricityAmount': electricityAmount.value,
        'waterUsed': waterConsumption.value,
        'waterAmount': waterAmount.value,
        'rentFee': double.tryParse(rentController.text) ?? 0.0,
        'wifiFee': double.tryParse(wifiController.text) ?? wifiRate.value,
        'trashFee': double.tryParse(trashController.text) ?? trashRate.value,
        'extraFee': double.tryParse(extraController.text) ?? 0.0,
        'parkingFee':
        double.tryParse(parkingController.text) ?? parkingRate.value,
        'totalAmount': totalAmount.value,
        'status': 'unpaid',
        'dueDate': dueDateFormatted,
      });

      // Save to Transactions subcollection
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(selectedTenantId)
          .collection('Transactions')
          .doc(monthYear)
          .set({
        'totalAmount': totalAmount.value,
        'datePaid': '',
        'proofOfPaymentUrl': '',
        'dueDate': dueDateFormatted,
        'status': 'unpaid',
        'validated': false,
        'validationDate': null,
        'receiptUrl': '',
      });

      // Clear input fields
      electricityPrevious.clear();
      electricityCurrent.clear();
      waterPrevious.clear();
      waterCurrent.clear();
      rentController.clear();
      extraController.clear();

      // Reset consumption and amounts
      electricityConsumption.value = 0;
      waterConsumption.value = 0;
      electricityAmount.value = 0.0;
      waterAmount.value = 0.0;
      totalAmount.value = 0.0;

      PLoaders.successSnackBar(
        title: 'Success',
        message: 'Billing saved successfully',
      );
    } catch (e) {
      PLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to save billing: $e',
      );
    }
  }

  @override
  void onClose() {
    electricityPrevious.dispose();
    electricityCurrent.dispose();
    waterPrevious.dispose();
    waterCurrent.dispose();
    rentController.dispose();
    trashController.dispose();
    wifiController.dispose();
    parkingController.dispose();
    extraController.dispose();
    super.onClose();
  }

  Future<List<String>> _getAvailableUnits(List<String> allUnits) async {
    final now = DateTime.now();
    final monthYear = DateFormat('yyyy-MM').format(now);
    final availableUnits = <String>[];

    for (final unit in allUnits) {
      // Find the unit document
      final unitQuery = await FirebaseFirestore.instance
          .collection('units')
          .where('unitNumber', isEqualTo: unit)
          .get();

      if (unitQuery.docs.isEmpty) {
        // If unit document doesn't exist, it's available
        availableUnits.add(unit);
        continue;
      }

      final unitDocId = unitQuery.docs.first.id;

      // Check if billing exists for this month
      final billingDoc = await FirebaseFirestore.instance
          .collection('units')
          .doc(unitDocId)
          .collection('Bills')
          .doc(monthYear)
          .get();

      // If no billing exists for this month, add to available units
      if (!billingDoc.exists) {
        availableUnits.add(unit);
      }
    }

    return availableUnits;
  }
}

class CreateBilling extends StatelessWidget {
  const CreateBilling({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox
        .shrink(); // This widget is only used for its static method
  }

  static void show(BuildContext context) {
    final controller = Get.put(BillingController());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Row(
            children: [
              const Text(
                'Create Billing',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.orange),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final electricityRateController = TextEditingController(
                          text: controller.electricityRate.value.toString());
                      final waterRateController = TextEditingController(
                          text: controller.waterRate.value.toString());
                      final wifiRateController = TextEditingController(
                          text: controller.wifiRate.value.toString());
                      final parkingRateController = TextEditingController(
                          text: controller.parkingRate.value.toString());
                      final trashRateController = TextEditingController(
                          text: controller.trashRate.value.toString());

                      return AlertDialog(
                        backgroundColor: const Color(0xFF1E1E1E),
                        title: const Text(
                          'Rate Settings',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: electricityRateController,
                              decoration: const InputDecoration(
                                labelText: 'Electricity Rate per Unit',
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: waterRateController,
                              decoration: const InputDecoration(
                                labelText: 'Water Rate per Unit',
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: wifiRateController,
                              decoration: InputDecoration(
                                labelText: 'WiFi Rate',
                                labelStyle: const TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.orange),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: parkingRateController,
                              decoration: InputDecoration(
                                labelText: 'Parking Rate',
                                labelStyle: const TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.orange),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: trashRateController,
                              decoration: InputDecoration(
                                labelText: 'Trash Rate',
                                labelStyle: const TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.orange),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
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
                            onPressed: () {
                              controller.updateRates(
                                double.tryParse(
                                    electricityRateController.text) ??
                                    0.0,
                                double.tryParse(waterRateController.text) ??
                                    0.0,
                                double.tryParse(wifiRateController.text) ?? 0.0,
                                double.tryParse(parkingRateController.text) ??
                                    0.0,
                                double.tryParse(trashRateController.text) ??
                                    0.0,
                              );
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unit Dropdown
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error loading units',
                          style: TextStyle(color: Colors.red));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Get all units
                    final units = snapshot.data!.docs
                        .map((doc) => doc['UnitNo'] as String)
                        .where((unit) => unit != null && unit.isNotEmpty)
                        .toList();

                    // Filter out units that already have billing for current month
                    return FutureBuilder<List<String>>(
                      future: controller._getAvailableUnits(units),
                      builder: (context, availableUnitsSnapshot) {
                        if (availableUnitsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final availableUnits =
                            availableUnitsSnapshot.data ?? [];

                        if (availableUnits.isEmpty) {
                          return const Text(
                            'No available units for billing this month',
                            style: TextStyle(color: Colors.orange),
                          );
                        }

                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Unit',
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.orange),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          dropdownColor: const Color(0xFF1E1E1E),
                          style: const TextStyle(color: Colors.white),
                          items: availableUnits.map((unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.selectedUnit = value;
                            // Get tenant ID for the selected unit
                            FirebaseFirestore.instance
                                .collection('Users')
                                .where('UnitNo', isEqualTo: value)
                                .get()
                                .then((snapshot) {
                              if (snapshot.docs.isNotEmpty) {
                                controller.selectedTenantId =
                                    snapshot.docs.first.id;
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Rent
                TextFormField(
                  controller: controller.rentController,
                  decoration: InputDecoration(
                    labelText: 'Rent',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: controller.validateAmount,
                ),
                const SizedBox(height: 20),

                // Electricity Row
                Row(
                  children: [
                    const Text('Electricity',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 8),
                    const Text('Consumption:',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 4),
                    Obx(() => Text(
                      '${controller.electricityConsumption}',
                      style: const TextStyle(color: Colors.orange),
                    )),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.electricityPrevious,
                        decoration: InputDecoration(
                          labelText: 'Previous Reading',
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        validator: controller.validateReading,
                        onChanged: (value) => controller.calculateConsumption(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: controller.electricityCurrent,
                        decoration: InputDecoration(
                          labelText: 'Current Reading',
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        validator: controller.validateReading,
                        onChanged: (value) => controller.calculateConsumption(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() => TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Electricity Amount',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  readOnly: true,
                  controller: TextEditingController(
                      text:
                      '₱${controller.electricityAmount.value.toStringAsFixed(2)}'),
                )),
                const SizedBox(height: 20),

                // Water Row
                Row(
                  children: [
                    const Text('Water', style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 8),
                    const Text('Consumption:',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 4),
                    Obx(() => Text(
                      '${controller.waterConsumption}',
                      style: const TextStyle(color: Colors.orange),
                    )),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.waterPrevious,
                        decoration: InputDecoration(
                          labelText: 'Previous Reading',
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        validator: controller.validateReading,
                        onChanged: (value) => controller.calculateConsumption(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: controller.waterCurrent,
                        decoration: InputDecoration(
                          labelText: 'Current Reading',
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        validator: controller.validateReading,
                        onChanged: (value) => controller.calculateConsumption(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() => TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Water Amount',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  readOnly: true,
                  controller: TextEditingController(
                      text:
                      '₱${controller.waterAmount.value.toStringAsFixed(2)}'),
                )),
                const SizedBox(height: 20),

                // Trash
                TextFormField(
                  controller: controller.trashController,
                  decoration: InputDecoration(
                    labelText: 'Trash',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: controller.validateAmount,
                ),
                const SizedBox(height: 20),

                // WiFi
                TextFormField(
                  controller: controller.wifiController,
                  decoration: InputDecoration(
                    labelText: 'Wi-Fi',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: controller.validateAmount,
                ),
                const SizedBox(height: 20),

                // Parking
                TextFormField(
                  controller: controller.parkingController,
                  decoration: InputDecoration(
                    labelText: 'Parking',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: controller.validateAmount,
                ),

                const SizedBox(height: 20),

                // Extra
                TextFormField(
                  controller: controller.extraController,
                  decoration: InputDecoration(
                    labelText: 'Extra',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: controller.validateAmount,
                ),
                const SizedBox(height: 20),

                // Total
                Obx(() => TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Total',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  readOnly: true,
                  controller: TextEditingController(
                      text:
                      '₱${controller.totalAmount.value.toStringAsFixed(2)}'),
                )),
              ],
            ),
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
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      title: const Text(
                        'Confirm Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Are you sure you want to save this billing?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close confirmation dialog
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Close both dialogs
                            Navigator.of(context)
                                .pop(); // Close confirmation dialog
                            Navigator.of(context)
                                .pop(); // Close the main form dialog
                            // Save to Firestore
                            controller.saveBilling();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text('Confirm'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
