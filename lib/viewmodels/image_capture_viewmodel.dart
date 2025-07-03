import 'dart:io';
import 'package:get/get.dart';
import '../core/errors/error_handler.dart';
import '../core/results/result.dart';
import '../core/state/view_state.dart';
import '../data/repositories/image_repository.dart';

class ImageCaptureViewModel extends GetxController {
  final IImageRepository _imageRepository;

  ImageCaptureViewModel(this._imageRepository);

  // Observable state
  final Rx<ViewStateWrapper<File?>> _imagePickerState =
      ViewStateWrapper<File?>.idle().obs;
  final Rx<ViewStateWrapper<File?>> _compressionState =
      ViewStateWrapper<File?>.idle().obs;

  // Getters
  ViewStateWrapper<File?> get imagePickerState => _imagePickerState.value;
  ViewStateWrapper<File?> get compressionState => _compressionState.value;

  // Check if any operation is in progress
  bool get isLoading =>
      imagePickerState.isLoading || compressionState.isLoading;

  // Captured image file
  File? get capturedImage => imagePickerState.data ?? compressionState.data;

  /// Pick image from camera
  Future<void> pickImageFromCamera() async {
    if (isLoading) return;

    _imagePickerState.value = ViewStateWrapper.loading(LoadingType.action);

    try {
      final result = await _imageRepository.pickImage(AppImageSource.camera);

      result.fold(
        (imageFile) async {
          _imagePickerState.value = ViewStateWrapper.success(imageFile);

          // Auto-compress the image
          await _compressImage(imageFile);
        },
        (error) {
          _imagePickerState.value = ViewStateWrapper.error(error.message);
          ErrorHandler.handleError(error);
        },
      );
    } catch (e) {
      final error = ErrorHandler.parseException(e);
      _imagePickerState.value = ViewStateWrapper.error(error.message);
      ErrorHandler.handleError(error);
    }
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    if (isLoading) return;

    _imagePickerState.value = ViewStateWrapper.loading(LoadingType.action);

    try {
      final result = await _imageRepository.pickImage(AppImageSource.gallery);

      result.fold(
        (imageFile) async {
          _imagePickerState.value = ViewStateWrapper.success(imageFile);

          // Auto-compress the image
          await _compressImage(imageFile);
        },
        (error) {
          _imagePickerState.value = ViewStateWrapper.error(error.message);
          ErrorHandler.handleError(error);
        },
      );
    } catch (e) {
      final error = ErrorHandler.parseException(e);
      _imagePickerState.value = ViewStateWrapper.error(error.message);
      ErrorHandler.handleError(error);
    }
  }

  /// Compress the captured image
  Future<void> _compressImage(File imageFile) async {
    _compressionState.value = ViewStateWrapper.loading(LoadingType.action);

    try {
      final result = await _imageRepository.compressImage(imageFile);

      result.fold(
        (compressedFile) {
          _compressionState.value = ViewStateWrapper.success(compressedFile);
        },
        (error) {
          _compressionState.value = ViewStateWrapper.error(error.message);
          // For compression errors, we can still continue with original image
          _compressionState.value = ViewStateWrapper.success(imageFile);
        },
      );
    } catch (e) {
      // Fallback to original image if compression fails
      _compressionState.value = ViewStateWrapper.success(imageFile);
    }
  }

  /// Validate the current image
  Future<bool> validateCurrentImage() async {
    final image = capturedImage;
    if (image == null) return false;

    final result = await _imageRepository.validateImage(image);
    return result.fold((isValid) => isValid, (error) {
      ErrorHandler.handleError(error);
      return false;
    });
  }

  /// Get image file size formatted
  Future<String> getImageSizeFormatted() async {
    final image = capturedImage;
    if (image == null) return 'N/A';

    final result = await _imageRepository.getImageSize(image);
    return result.fold(
      (size) => _imageRepository.formatFileSize(size),
      (error) => 'N/A',
    );
  }

  /// Reset all states
  void resetStates() {
    _imagePickerState.value = ViewStateWrapper<File?>.idle();
    _compressionState.value = ViewStateWrapper<File?>.idle();
  }

  /// Clear captured image
  void clearImage() {
    resetStates();
  }

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}
