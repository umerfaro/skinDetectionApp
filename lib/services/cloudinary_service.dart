import 'dart:io';
import 'package:cloudinary/cloudinary.dart';

class CloudinaryService {
  // Replace these with your actual Cloudinary credentials
  static const String cloudName = '';
  static const String apiKey = '';
  static const String apiSecret = '';

  static final cloudinary = Cloudinary.signedConfig(
    apiKey: apiKey,
    apiSecret: apiSecret,
    cloudName: cloudName,
  );

  /// Upload image to Cloudinary and return the secure URL
  static Future<String> uploadImage(File imageFile) async {
    try {
      final response = await cloudinary.upload(
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'skin_analysis',
        fileName: 'skin_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (response.isSuccessful && response.secureUrl != null) {
        return response.secureUrl!;
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      throw Exception('Cloudinary upload error: $e');
    }
  }

  /// Upload image with specific transformations for medical analysis
  static Future<String> uploadImageForAnalysis(File imageFile) async {
    try {
      // Upload with optimized settings for medical analysis
      final response = await cloudinary.upload(
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'skin_analysis',
        fileName: 'analysis_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (response.isSuccessful && response.secureUrl != null) {
        // You can append transformations to the URL if needed
        // Example: ${response.secureUrl}?q_auto:best,w_1024,h_1024,c_limit
        return response.secureUrl!;
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      throw Exception('Cloudinary upload error: $e');
    }
  }

  /// Delete image from Cloudinary (optional cleanup)
  static Future<bool> deleteImage(String publicId) async {
    try {
      final response = await cloudinary.destroy(
        publicId,
        resourceType: CloudinaryResourceType.image,
      );
      return response.isSuccessful;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }
}
