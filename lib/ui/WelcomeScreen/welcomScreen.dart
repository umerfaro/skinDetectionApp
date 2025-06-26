import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/colors.dart';
import '../../controller/welcomeController.dart';

// --- Welcome Screen Widget ---
// This is the main screen that the user sees when they open the app.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WelcomeController());

    return Scaffold(
      // The app bar of the screen.
      appBar: AppBar(
        // The background color of the app bar.
        backgroundColor: Colors.transparent,
        // The elevation of the app bar.
        elevation: 0,
        // The title of the app bar.
        title: const Text(
          'SkinSleuth AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // The actions of the app bar.
        actions: [
          IconButton(
            // The icon of the button.
            icon: const Icon(Icons.help_outline),
            // The action to perform when the button is pressed.
            onPressed: () {
              // TODO: Implement help/info screen navigation
            },
          ),
        ],
      ),
      // The body of the screen.
      body: const Padding(
        // The padding of the body.
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        // The child of the body.
        child: WelcomeScreenContent(),
      ),
    );
  }
}

// --- Reusable Welcome Screen Content ---
// This widget contains the main content of the welcome screen.
class WelcomeScreenContent extends StatelessWidget {
  const WelcomeScreenContent({super.key});

  // Get controller instance
  WelcomeController get controller => Get.find<WelcomeController>();

  @override
  Widget build(BuildContext context) {
    // Get the text theme from the current context.
    final textTheme = Theme.of(context).textTheme;

    return Column(
      // The alignment of the column.
      mainAxisAlignment: MainAxisAlignment.center,
      // The children of the column.
      children: [
        // The title of the screen.
        Text(
          'Welcome to Your Skin Health Companion',
          // The alignment of the text.
          textAlign: TextAlign.center,
          // The style of the text.
          style: textTheme.headlineMedium,
        ),
        // The space between the title and the subtitle.
        const SizedBox(height: 16),
        // The subtitle of the screen.
        Text(
          'Instantly analyze your skin. Capture a new image or upload one from your gallery to get started with our AI-powered detector.',
          // The alignment of the text.
          textAlign: TextAlign.center,
          // The style of the text.
          style: textTheme.bodyLarge?.copyWith(fontSize: 16),
        ),
        // The space between the subtitle and the buttons.
        const SizedBox(height: 48),
        // The "Capture New Image" button.
        Obx(
          () => _buildActionButton(
            context: context,
            text: 'Capture New Image',
            icon: Icons.camera_alt_outlined,
            isPrimary: true,
            isLoading: controller.isCameraLoading.value,
            onPressed:
                (controller.isCameraLoading.value ||
                    controller.isGalleryLoading.value)
                ? null
                : () => controller.pickImageFromCamera(),
          ),
        ),
        // The space between the buttons.
        const SizedBox(height: 16),
        // The "Upload from Gallery" button.
        Obx(
          () => _buildActionButton(
            context: context,
            text: 'Upload from Gallery',
            icon: Icons.upload_file_outlined,
            isLoading: controller.isGalleryLoading.value,
            onPressed:
                (controller.isCameraLoading.value ||
                    controller.isGalleryLoading.value)
                ? null
                : () => controller.pickImageFromGallery(),
          ),
        ),
      ],
    );
  }

  // --- Helper method to build action buttons on the welcome screen ---
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
