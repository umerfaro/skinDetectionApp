import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/errors/app_error.dart';
import '../core/errors/error_handler.dart';
import '../core/results/result.dart';
import '../core/state/view_state.dart';
import '../data/repositories/skin_analysis_repository.dart';
import '../data/repositories/skin_report_repository.dart';
import '../models/analysis_result.dart';
import '../models/skin_report_enhanced.dart';

class SkinAnalysisViewModel extends GetxController {
  final ISkinAnalysisRepository _analysisRepository;
  final ISkinReportRepository _reportRepository;

  SkinAnalysisViewModel(this._analysisRepository, this._reportRepository);

  // Observable states
  final Rx<ViewStateWrapper<AnalysisResult?>> _analysisState =
      ViewStateWrapper<AnalysisResult?>.idle().obs;
  final Rx<ViewStateWrapper<SkinReportEnhanced?>> _saveReportState =
      ViewStateWrapper<SkinReportEnhanced?>.idle().obs;

  // Getters
  ViewStateWrapper<AnalysisResult?> get analysisState => _analysisState.value;
  ViewStateWrapper<SkinReportEnhanced?> get saveReportState =>
      _saveReportState.value;

  bool get isAnalyzing => analysisState.isLoading;
  bool get isSavingReport => saveReportState.isLoading;
  bool get isLoading => isAnalyzing || isSavingReport;

  AnalysisResult? get currentAnalysis => analysisState.data;
  SkinReportEnhanced? get savedReport => saveReportState.data;

  /// Analyze the provided image
  Future<void> analyzeImage(File imageFile) async {
    if (isAnalyzing) return;

    _analysisState.value = ViewStateWrapper.loading(LoadingType.action);

    try {
      final result = await _analysisRepository.analyzeImage(imageFile);

      result.fold(
        (analysisResult) {
          _analysisState.value = ViewStateWrapper.success(analysisResult);
        },
        (error) {
          _analysisState.value = ViewStateWrapper.error(error.message);
          ErrorHandler.handleError(error);
        },
      );
    } catch (e) {
      final error = ErrorHandler.parseException(e);
      _analysisState.value = ViewStateWrapper.error(error.message);
      ErrorHandler.handleError(error);
    }
  }

  /// Use mock analysis for testing
  Future<void> mockAnalyzeImage(File imageFile) async {
    if (isAnalyzing) return;

    _analysisState.value = ViewStateWrapper.loading(LoadingType.action);

    try {
      final repository = _analysisRepository as SkinAnalysisRepository;
      final result = await repository.mockAnalyzeImage(imageFile);

      result.fold(
        (analysisResult) {
          _analysisState.value = ViewStateWrapper.success(analysisResult);
        },
        (error) {
          _analysisState.value = ViewStateWrapper.error(error.message);
          ErrorHandler.handleError(error);
        },
      );
    } catch (e) {
      final error = ErrorHandler.parseException(e);
      _analysisState.value = ViewStateWrapper.error(error.message);
      ErrorHandler.handleError(error);
    }
  }

  /// Save analysis result as a report
  Future<void> saveAnalysisAsReport(String imagePath, {String? notes}) async {
    final analysis = currentAnalysis;
    if (analysis == null) {
      ErrorHandler.handleError(
        AppError.validation(message: 'No analysis result to save'),
      );
      return;
    }

    if (isSavingReport) return;

    _saveReportState.value = ViewStateWrapper.loading(LoadingType.action);

    try {
      final report = SkinReportEnhanced.fromAnalysisResult(
        imagePath: imagePath,
        analysisResult: analysis,
        notes: notes,
      );

      final result = await _reportRepository.saveReport(report);

      result.fold(
        (savedReport) {
          _saveReportState.value = ViewStateWrapper.success(savedReport);

          // Show success message
          Get.snackbar(
            'Success',
            'Analysis report saved successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (error) {
          _saveReportState.value = ViewStateWrapper.error(error.message);
          ErrorHandler.handleError(error);
        },
      );
    } catch (e) {
      final error = ErrorHandler.parseException(e);
      _saveReportState.value = ViewStateWrapper.error(error.message);
      ErrorHandler.handleError(error);
    }
  }

  /// Get risk level color for UI
  Color getRiskLevelColor() {
    final analysis = currentAnalysis;
    if (analysis?.riskLevel == null) return Colors.grey;

    switch (analysis!.riskLevel!) {
      case RiskLevel.low:
        return Colors.green;
      case RiskLevel.medium:
        return Colors.orange;
      case RiskLevel.high:
        return Colors.red;
      case RiskLevel.critical:
        return Colors.red.shade800;
    }
  }

  /// Get severity level color for UI
  Color getSeverityLevelColor() {
    final analysis = currentAnalysis;
    if (analysis?.severity == null) return Colors.grey;

    switch (analysis!.severity!) {
      case SeverityLevel.mild:
        return Colors.green;
      case SeverityLevel.moderate:
        return Colors.orange;
      case SeverityLevel.severe:
        return Colors.red;
      case SeverityLevel.critical:
        return Colors.red.shade800;
    }
  }

  /// Check if analysis indicates high risk
  bool get hasHighRiskResult {
    final analysis = currentAnalysis;
    return analysis?.riskLevel == RiskLevel.high ||
        analysis?.riskLevel == RiskLevel.critical ||
        analysis?.severity == SeverityLevel.severe ||
        analysis?.severity == SeverityLevel.critical;
  }

  /// Get confidence percentage as string
  String get confidencePercentage {
    final confidence = currentAnalysis?.confidence;
    if (confidence == null) return 'N/A';
    return '${(confidence * 100).toStringAsFixed(1)}%';
  }

  /// Clear analysis results
  void clearAnalysis() {
    _analysisState.value = ViewStateWrapper<AnalysisResult?>.idle();
    _saveReportState.value = ViewStateWrapper<SkinReportEnhanced?>.idle();
  }

  /// Reset all states
  void resetStates() {
    clearAnalysis();
  }

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}
