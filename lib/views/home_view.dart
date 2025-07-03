import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../consts/colors.dart';
import '../viewmodels/image_capture_viewmodel.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/home/welcome_content.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final imageCaptureVM = Get.find<ImageCaptureViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'SkinSleuth AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        return LoadingOverlay(
          isLoading: imageCaptureVM.isLoading,
          loadingText: _getLoadingText(imageCaptureVM),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: WelcomeContent(),
          ),
        );
      }),
    );
  }

  String _getLoadingText(ImageCaptureViewModel viewModel) {
    if (viewModel.imagePickerState.isLoading) {
      return 'Capturing image...';
    } else if (viewModel.compressionState.isLoading) {
      return 'Processing image...';
    }
    return 'Loading...';
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Capture a photo of your skin condition using the camera'),
            SizedBox(height: 8),
            Text('2. Or upload an existing photo from your gallery'),
            SizedBox(height: 8),
            Text('3. Review and confirm the image'),
            SizedBox(height: 8),
            Text('4. Get AI-powered analysis results'),
            SizedBox(height: 8),
            Text('5. Save reports for future reference'),
            SizedBox(height: 16),
            Text(
              'Note: This is not a substitute for professional medical advice.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Got it')),
        ],
      ),
    );
  }
}
