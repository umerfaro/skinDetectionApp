import 'dart:io';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import '../../core/results/result.dart';
import '../../models/analysis_result.dart';
import '../../services/cloudinary_service.dart';
import '../../services/replicate_service.dart';

abstract class ISkinAnalysisRepository {
  Future<Result<AnalysisResult>> analyzeImage(File imageFile);
  Future<Result<String>> uploadImage(File imageFile);
}

class SkinAnalysisRepository implements ISkinAnalysisRepository {
  @override
  Future<Result<AnalysisResult>> analyzeImage(File imageFile) async {
    try {
      // Validate file
      if (!await imageFile.exists()) {
        return Failure(
          AppError.validation(message: 'Image file does not exist'),
        );
      }

      // Check file size (optional validation)
      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        // 10MB limit
        return Failure(
          AppError.validation(
            message: 'Image file is too large. Please select a smaller image.',
          ),
        );
      }

      // Analyze using Replicate service
      final response = await ReplicateService.analyzeImage(imageFile);

      if (response['success'] == true && response['data'] != null) {
        final analysisResult = AnalysisResult.fromMap(response['data']);
        return Success(analysisResult);
      } else {
        return Failure(
          AppError.server(message: response['error'] ?? 'Analysis failed'),
        );
      }
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  @override
  Future<Result<String>> uploadImage(File imageFile) async {
    try {
      // Validate file
      if (!await imageFile.exists()) {
        return Failure(
          AppError.validation(message: 'Image file does not exist'),
        );
      }

      final imageUrl = await CloudinaryService.uploadImageForAnalysis(
        imageFile,
      );
      return Success(imageUrl);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  // For development/testing - mock analysis
  Future<Result<AnalysisResult>> mockAnalyzeImage(File imageFile) async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API delay

      final mockData = {
        'diagnosis': 'Benign Mole',
        'confidence': 0.85,
        'severity': 'Mild',
        'recommendations': [
          'Monitor for changes in size or color',
          'Schedule regular skin check-ups',
          'Use sunscreen regularly',
        ],
        'description':
            'This appears to be a benign mole with regular borders and uniform coloration.',
        'risk_level': 'Low',
        'followUp': 'Routine check-up in 6 months',
      };

      final analysisResult = AnalysisResult.fromMap(mockData);
      return Success(analysisResult);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }
}
