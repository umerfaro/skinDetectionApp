import 'dart:io';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import '../../core/results/result.dart';

enum AppImageSource { camera, gallery }

abstract class IImageRepository {
  Future<Result<File>> pickImage(AppImageSource source);
  Future<Result<File>> compressImage(File imageFile);
  Future<Result<bool>> validateImage(File imageFile);
  Future<Result<int>> getImageSize(File imageFile);
  String formatFileSize(int bytes);
}

class ImageRepository implements IImageRepository {
  final picker.ImagePicker _picker = picker.ImagePicker();

  @override
  Future<Result<File>> pickImage(AppImageSource source) async {
    try {
      final picker.ImageSource pickerSource = source == AppImageSource.camera
          ? picker.ImageSource.camera
          : picker.ImageSource.gallery;

      final picker.XFile? pickedFile = await _picker.pickImage(
        source: pickerSource,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (pickedFile == null) {
        return Failure(AppError.validation(message: 'No image selected'));
      }

      final file = File(pickedFile.path);

      // Validate the picked image
      final validationResult = await validateImage(file);
      if (validationResult.isFailure) {
        return Failure(validationResult.error!);
      }

      return Success(file);
    } catch (e, stackTrace) {
      AppError error;

      if (e.toString().contains('permission')) {
        error = AppError.permission(
          message: 'Permission denied. Please grant camera/storage permission.',
          originalError: e,
          stackTrace: stackTrace,
        );
      } else {
        error = ErrorHandler.parseException(e, stackTrace);
      }

      return Failure(error);
    }
  }

  @override
  Future<Result<File>> compressImage(File imageFile) async {
    try {
      // Validate input file
      if (!await imageFile.exists()) {
        return Failure(
          AppError.validation(message: 'Image file does not exist'),
        );
      }

      final filePath = imageFile.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'\.'));
      final splitted = filePath.substring(0, lastIndex);
      final outPath = "${splitted}_compressed.jpg";

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        outPath,
        quality: 70,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      if (compressedFile != null) {
        return Success(File(compressedFile.path));
      } else {
        // Return original file if compression fails
        return Success(imageFile);
      }
    } catch (e, stackTrace) {
      final error = AppError.imageProcessing(
        message: 'Failed to compress image: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      );
      return Failure(error);
    }
  }

  @override
  Future<Result<bool>> validateImage(File imageFile) async {
    try {
      // Check if file exists
      if (!await imageFile.exists()) {
        return Failure(
          AppError.validation(message: 'Image file does not exist'),
        );
      }

      // Check file size (10MB limit)
      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        return Failure(
          AppError.validation(
            message: 'Image file is too large. Maximum size is 10MB.',
          ),
        );
      }

      // Check if file is too small (1KB minimum)
      if (fileSize < 1024) {
        return Failure(
          AppError.validation(message: 'Image file is too small.'),
        );
      }

      // Check file extension
      final path = imageFile.path.toLowerCase();
      final validExtensions = ['.jpg', '.jpeg', '.png', '.bmp', '.gif'];
      final hasValidExtension = validExtensions.any(
        (ext) => path.endsWith(ext),
      );

      if (!hasValidExtension) {
        return Failure(
          AppError.validation(
            message:
                'Invalid image format. Please select a JPG, PNG, BMP, or GIF image.',
          ),
        );
      }

      return const Success(true);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  // Utility methods
  Future<Result<int>> getImageSize(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        return Failure(
          AppError.validation(message: 'Image file does not exist'),
        );
      }

      final size = await imageFile.length();
      return Success(size);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
