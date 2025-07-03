import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/colors.dart';
import '../../viewmodels/skin_analysis_viewmodel.dart';
import '../../viewmodels/image_capture_viewmodel.dart';
import '../../ui/ReportScreen/ReportScreen.dart';

// --- Confirm Image Screen ---
// This screen is displayed after the user selects an image.
class ConfirmImageScreen extends StatelessWidget {
  final String imagePath;

  const ConfirmImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final analysisVM = Get.find<SkinAnalysisViewModel>();
    final imageCaptureVM = Get.find<ImageCaptureViewModel>();

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
                      onPressed: analysisVM.isAnalyzing
                          ? null
                          : () => _confirmImage(analysisVM),
                      icon: analysisVM.isAnalyzing
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
                        analysisVM.isAnalyzing
                            ? 'Analyzing...'
                            : 'Confirm & Analyze',
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
                        onPressed: () => _retakeImage(imageCaptureVM),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSecondaryActionButton(
                        text: 'Reselect',
                        icon: Icons.upload_file_outlined,
                        onPressed: () => _reselectImage(imageCaptureVM),
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

  // Confirm image and start analysis
  Future<void> _confirmImage(SkinAnalysisViewModel analysisVM) async {
    try {
      final imageFile = File(imagePath);
      await analysisVM.analyzeImage(imageFile);

      if (analysisVM.currentAnalysis != null) {
        final analysis = analysisVM.currentAnalysis!;

        // Ensure all data types are correct and handle nulls properly
        final analysisResultData = <String, dynamic>{
          'diagnosis': analysis.diagnosis,
          'description': analysis.description,
          'confidence': analysis.confidence ?? 0.0,
          'severity': analysis.severity?.value ?? 'Unknown',
          'risk_level': analysis.riskLevel?.value ?? 'Unknown',
          'recommendations': List<String>.from(analysis.recommendations),
          'followUp':
              analysis.followUp ?? 'Consult with a healthcare professional',
          'raw_output': analysis.rawOutput ?? <String, dynamic>{},
        };

        final mockAnalysisResult = <String, dynamic>{
          'success': true,
          'data': analysisResultData,
        };

        // Navigate to report screen
        Get.to(
          () => ReportScreen(
            imagePath: imagePath,
            analysisResult: mockAnalysisResult,
          ),
        );
      } else {
        // No analysis result available
        Get.snackbar(
          'Error',
          'No analysis result available. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to analyze image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Retake image (go back and open camera)
  void _retakeImage(ImageCaptureViewModel imageCaptureVM) {
    Get.back(); // Go back to home screen
    // Trigger camera capture
    Future.delayed(const Duration(milliseconds: 300), () {
      imageCaptureVM.pickImageFromCamera();
    });
  }

  // Reselect image (go back and open gallery)
  void _reselectImage(ImageCaptureViewModel imageCaptureVM) {
    Get.back(); // Go back to home screen
    // Trigger gallery selection
    Future.delayed(const Duration(milliseconds: 300), () {
      imageCaptureVM.pickImageFromGallery();
    });
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
