import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/colors.dart';
import '../../controller/confirmImageController.dart';

// --- Confirm Image Screen ---
// This screen is displayed after the user selects an image.
class ConfirmImageScreen extends StatelessWidget {
  final String imagePath;

  const ConfirmImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfirmImageController());
    controller.initializeImage(File(imagePath));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Confirm Image',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                // Display the selected image.
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 48),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Instructional text.
                const Text(
                  'Ensure the image is clear, well-lit, and the affected area is fully visible.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            // Action buttons at the bottom.
            Column(
              children: [
                // The "Confirm" button.
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.isProcessing.value
                          ? null
                          : controller.confirmImage,
                      icon: controller.isProcessing.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.check_circle_outline,
                              color: AppColors.iconOnPrimaryButton,
                            ),
                      label: Text(
                        controller.isProcessing.value
                            ? 'Processing...'
                            : 'Confirm',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textOnPrimaryButton,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryButton,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // The "Retake" and "Reselect" buttons.
                Row(
                  children: [
                    Expanded(
                      child: _buildSecondaryActionButton(
                        text: 'Retake',
                        icon: Icons.camera_alt_outlined,
                        onPressed: controller.retakeImage,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSecondaryActionButton(
                        text: 'Reselect',
                        icon: Icons.upload_file_outlined,
                        onPressed: controller.reselectImage,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build secondary action buttons on the confirm screen.
  Widget _buildSecondaryActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.iconOnSecondaryButton),
      label: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryButton,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
