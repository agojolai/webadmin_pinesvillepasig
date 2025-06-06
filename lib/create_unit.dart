import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class CreateUnitDialog extends StatefulWidget {
  const CreateUnitDialog({super.key});

  @override
  State<CreateUnitDialog> createState() => _CreateUnitDialogState();
}

class _CreateUnitDialogState extends State<CreateUnitDialog> {
  final unitNumberController = TextEditingController();
  final sizeController = TextEditingController();
  final rentController = TextEditingController();
  final maxOccupantsController = TextEditingController();
  final descriptionController = TextEditingController();

  String furnishing = 'Furnished';
  String unitType = 'Studio Type Loft';
  final selectedAmenities = <String>{};
  final List<XFile> _pickedFiles = [];
  final List<Uint8List> _imageBytesList = [];
  final List<String> _uploadedImageUrls = [];

  final Map<String, String?> _validationErrors = {};

  final amenities = [
    "Electricity Submeter", "Water Submeter", "Wi-Fi (Shared)", "Parking (Motorcycle)", "Restroom",
    "Airconditioning", "Airconditioning (w/ provision)", "Airconditioning (w/o provision)",
    "Sink", "Bidet", "Shower (w/ heater provision)", "Shower (w/o heater provision)",
  ];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images != null) {
      for (final image in images) {
        final bytes = await image.readAsBytes();
        _pickedFiles.add(image);
        _imageBytesList.add(bytes);
      }
      setState(() {});
    }
  }

  Future<void> _uploadImages() async {
    _uploadedImageUrls.clear();
    for (final image in _pickedFiles) {
      final fileName = const Uuid().v4();
      final ref = FirebaseStorage.instance.ref().child('unit_images/$fileName.jpg');
      await ref.putData(await image.readAsBytes());
      final url = await ref.getDownloadURL();
      _uploadedImageUrls.add(url);
    }
  }

  bool _validateInputs() {
    _validationErrors.clear();

    if (unitNumberController.text.trim().isEmpty) {
      _validationErrors['unitNumber'] = 'Unit Number is required';
    }
    if (sizeController.text.trim().isEmpty) {
      _validationErrors['size'] = 'Unit Area/Size is required';
    }
    if (rentController.text.trim().isEmpty || int.tryParse(rentController.text) == null) {
      _validationErrors['rent'] = 'Rent Amount required';
    }
    if (maxOccupantsController.text.trim().isEmpty || int.tryParse(maxOccupantsController.text) == null) {
      _validationErrors['maxOccupants'] = 'Number of occupants required';
    }
    if (descriptionController.text.trim().isEmpty) {
      _validationErrors['description'] = 'Description is required';
    }
    if (_imageBytesList.isEmpty) {
      _validationErrors['images'] = 'At least one image is required';
    }

    setState(() {});
    return _validationErrors.isEmpty;
  }

  Future<void> _createUnit() async {
    if (!_validateInputs()) return;

    await _uploadImages();

    final unitData = {
      'unitNumber': unitNumberController.text,
      'status': 'Vacant',
      'price': int.tryParse(rentController.text) ?? 0,
      'Unit Type': unitType,
      'tenantId': '',
      'maintenance': 'None',
      'Details': {
        'size': sizeController.text,
        'monthlyRent': int.tryParse(rentController.text) ?? 0,
        'maxOccupants': int.tryParse(maxOccupantsController.text) ?? 1,
        'furnishing': furnishing,
        'amenities': selectedAmenities.toList(),
        'description': descriptionController.text,
        'images': _uploadedImageUrls,
      },
    };

    await FirebaseFirestore.instance.collection('units').add(unitData);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      insetPadding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create new unit",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildInput("Unit Number", unitNumberController, errorKey: 'unitNumber'),
                _buildInput("Size / Area", sizeController, errorKey: 'size'),
                _buildInput("Monthly Rent", rentController, errorKey: 'rent'),
                _buildInput("Max. No. of Occupants", maxOccupantsController, errorKey: 'maxOccupants'),
                _buildDropdown("Furnishing", ['Bare Unit', 'Semi-furnished', 'Furnished'], (value) {
                  setState(() => furnishing = value!);
                }, furnishing),
                _buildDropdown("Unit Type", ['Studio Type Loft', '1 BR', '2 BR'], (value) {
                  setState(() => unitType = value!);
                }, unitType),
              ],
            ),
            const SizedBox(height: 24),
            Text("Features & Amenities",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: amenities.map((amenity) {
                return SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      Checkbox(
                        value: selectedAmenities.contains(amenity),
                        onChanged: (checked) {
                          setState(() {
                            if (checked!) {
                              selectedAmenities.add(amenity);
                            } else {
                              selectedAmenities.remove(amenity);
                            }
                          });
                        },
                      ),
                      Expanded(child: Text(amenity, style: const TextStyle(color: Colors.white))),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text("Description",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                hintText: "Type something...",
                hintStyle: const TextStyle(color: Colors.grey),
                errorText: _validationErrors['description'],
              ),
            ),
            const SizedBox(height: 24),
            Text("Images",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _imageBytesList.isEmpty
                  ? Center(
                child: GestureDetector(
                  onTap: _pickImages,
                  child: Text(
                    "Upload some images from your file...",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
                  : GridView.builder(
                itemCount: _imageBytesList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _imageBytesList[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _imageBytesList.removeAt(index);
                              _pickedFiles.removeAt(index);
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (_validationErrors.containsKey('images'))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _validationErrors['images']!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _createUnit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  child: const Text("Create"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {String? errorKey}) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          errorText: errorKey != null ? _validationErrors[errorKey] : null,
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, void Function(String?) onChanged, String value) {
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
        dropdownColor: const Color(0xFF2A2A2A),
        style: const TextStyle(color: Colors.white),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      ),
    );
  }
}
