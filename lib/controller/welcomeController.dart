import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
//import 'package:permission_handler/permission_handler.dart';
import '../consts/consts.dart';
import '../consts/utils.dart';
import '../ui/ConfirmImageScreen/ConfirmImageScreen.dart';

class WelcomeController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var isCameraLoading = false.obs;
  var isGalleryLoading = false.obs;

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      isCameraLoading.value = true;

      // Camera permission will be handled by image_picker automatically

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        await _processAndNavigateToConfirm(File(image.path));
      }
    } catch (e) {
      Utils.showSnackBar(
        title: 'Error',
        message: 'Failed to capture image: $e',
      );
    } finally {
      isCameraLoading.value = false;
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      isGalleryLoading.value = true;

      // Storage permission will be handled by image_picker automatically

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        await _processAndNavigateToConfirm(File(image.path));
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Error', message: 'Failed to pick image: $e');
    } finally {
      isGalleryLoading.value = false;
    }
  }

  // Compress image and navigate to confirm screen
  Future<void> _processAndNavigateToConfirm(File imageFile) async {
    try {
      // Compress the image
      final compressedFile = await _compressImage(imageFile);

      if (compressedFile != null) {
        // Navigate to confirm screen with compressed image
        Get.to(() => ConfirmImageScreen(imagePath: compressedFile.path));
      } else {
        Utils.showSnackBar(title: 'Error', message: 'Failed to process image');
      }
    } catch (e) {
      Utils.showSnackBar(
        title: 'Error',
        message: 'Failed to process image: $e',
      );
    }
  }

  // Compress image using flutter_image_compress
  Future<File?> _compressImage(File file) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'\.'));
      final splitted = filePath.substring(0, lastIndex);
      final outPath = "${splitted}_compressed.jpg";

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      if (compressedFile != null) {
        return File(compressedFile.path);
      }
      return null;
    } catch (e) {
      print('Error compressing image: $e');
      return file; // Return original file if compression fails
    }
  }
}
