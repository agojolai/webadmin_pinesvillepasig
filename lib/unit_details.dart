import 'package:flutter/material.dart';

import 'image_viewer.dart';

class UnitDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> unitData;

  const UnitDetailsDialog({super.key, required this.unitData});

  @override
  Widget build(BuildContext context) {
    final details = unitData['Details'] ?? {};
    final amenities = details['amenities'] ?? [];
    final List images = details['images'] ?? [];

    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      insetPadding: const EdgeInsets.all(40),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Unit ${unitData['unitNumber']}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: images.isNotEmpty
                    ? PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => FullscreenImageViewer(images: images, initialIndex: index),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Center(child: Icon(Icons.broken_image, color: Colors.white54)),
                        ),
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Text("No images available", style: TextStyle(color: Colors.white54)),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Description", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                details['description'] ?? 'No description provided.',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              const Text("Details", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 50,
                runSpacing: 12,
                children: [
                  detailItem("Size / Area", details['size'] ?? "N/A"),
                  detailItem("Monthly Rent", "₱${details['monthlyRent'] ?? "0"}"),
                  detailItem("Max No. of Occupants", "${details['maxOccupants'] ?? "N/A"}"),
                  detailItem("Furnishing", details['furnishing'] ?? "N/A"),
                ],
              ),
              const SizedBox(height: 24),
              const Text("What this place offers", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 50,
                runSpacing: 8,
                children: List<Widget>.from(
                  (amenities as List<dynamic>).map((amenity) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(amenity, style: const TextStyle(color: Colors.white)),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
