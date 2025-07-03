import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/colors.dart';
import '../../core/state/view_state.dart';
import '../../viewmodels/image_capture_viewmodel.dart';
import '../../ui/ConfirmImageScreen/ConfirmImageScreen.dart';

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final imageCaptureVM = Get.find<ImageCaptureViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome to Your Skin Health Companion',
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Text(
          'Instantly analyze your skin. Capture a new image or upload one from your gallery to get started with our AI-powered detector.',
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 48),
        Obx(
          () => _buildActionButton(
            context: context,
            text: 'Capture New Image',
            icon: Icons.camera_alt_outlined,
            isPrimary: true,
            isLoading:
                imageCaptureVM.imagePickerState.isLoading &&
                imageCaptureVM.imagePickerState.loadingType ==
                    LoadingType.action,
            onPressed: imageCaptureVM.isLoading
                ? null
                : () async {
                    await imageCaptureVM.pickImageFromCamera();
                    if (imageCaptureVM.capturedImage != null) {
                      // Navigate to confirm screen
                      Get.to(
                        () => ConfirmImageScreen(
                          imagePath: imageCaptureVM.capturedImage!.path,
                        ),
                      );
                    }
                  },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => _buildActionButton(
            context: context,
            text: 'Upload from Gallery',
            icon: Icons.upload_file_outlined,
            isLoading:
                imageCaptureVM.imagePickerState.isLoading &&
                imageCaptureVM.imagePickerState.loadingType ==
                    LoadingType.action,
            onPressed: imageCaptureVM.isLoading
                ? null
                : () async {
                    await imageCaptureVM.pickImageFromGallery();
                    if (imageCaptureVM.capturedImage != null) {
                      // Navigate to confirm screen
                      Get.to(
                        () => ConfirmImageScreen(
                          imagePath: imageCaptureVM.capturedImage!.path,
                        ),
                      );
                    }
                  },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
    bool isPrimary = false,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Icon(
                icon,
                color: isPrimary
                    ? AppColors.iconOnPrimaryButton
                    : AppColors.iconOnSecondaryButton,
              ),
        label: Text(
          isLoading ? 'Processing...' : text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isPrimary
                ? AppColors.textOnPrimaryButton
                : AppColors.textPrimary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? AppColors.primaryButton
              : AppColors.secondaryButton,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
