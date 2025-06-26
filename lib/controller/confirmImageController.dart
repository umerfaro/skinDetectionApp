import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../consts/consts.dart';
import '../consts/utils.dart';
import '../services/replicate_service.dart';
import '../ui/ReportScreen/ReportScreen.dart';

class ConfirmImageController extends GetxController {
  late File imageFile;
  var isProcessing = false.obs;

  void initializeImage(File file) {
    imageFile = file;
  }

  // Confirm the selected image and process it
  Future<void> confirmImage() async {
    try {
      isProcessing.value = true;

      // Call Replicate API for skin analysis
      // Using mock data for now - replace with ReplicateService.analyzeImage(imageFile) when ready
      final result = await ReplicateService.analyzeImage(imageFile);

      if (result['success']) {
        // Navigate to report screen with results
        Get.to(
          () => ReportScreen(imagePath: imageFile.path, analysisResult: result),
        );
      } else {
        print(result['error']);

        Utils.showSnackBar(
          title: 'Analysis Failed',
          message: result['error'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      Utils.showSnackBar(
        title: 'Error',
        message: 'Failed to analyze image: $e',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  // Retake image (go back and open camera)
  void retakeImage() {
    Get.back(); // Go back to welcome screen
    // The welcome screen controller will handle camera opening
  }

  // Reselect image (go back and open gallery)
  void reselectImage() {
    Get.back(); // Go back to welcome screen
    // The welcome screen controller will handle gallery opening
  }

  // Delete temporary files when controller is disposed
  @override
  void onClose() {
    try {
      if (imageFile.existsSync()) {
        imageFile.deleteSync();
      }
    } catch (e) {
      print('Error deleting temporary file: $e');
    }
    super.onClose();
  }
}
