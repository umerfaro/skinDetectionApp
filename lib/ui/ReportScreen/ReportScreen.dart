import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/colors.dart';
import '../../models/skin_report_enhanced.dart';
import '../../models/analysis_result.dart';
import '../../data/repositories/skin_report_repository.dart';
import '../../core/results/result.dart';
import '../../viewmodels/skin_report_history_viewmodel.dart';

class ReportScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> analysisResult;

  const ReportScreen({
    super.key,
    required this.imagePath,
    required this.analysisResult,
  });

  @override
  Widget build(BuildContext context) {
    final reportRepository = Get.find<ISkinReportRepository>();
    final historyVM = Get.find<SkinReportHistoryViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Analysis Report',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            _buildImageSection(),
            const SizedBox(height: 24),

            // Analysis Results Section
            _buildAnalysisSection(),
            const SizedBox(height: 24),

            // Recommendations Section
            _buildRecommendationsSection(),
            const SizedBox(height: 24),

            // Disclaimer
            _buildDisclaimer(),
            const SizedBox(height: 32),

            // Save Report Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _saveReport(reportRepository, historyVM);
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButton,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Future<void> _saveReport(
    ISkinReportRepository reportRepository,
    SkinReportHistoryViewModel historyVM,
  ) async {
    try {
      final data = analysisResult['data'] as Map<String, dynamic>;

      // Create analysis result first
      final analysis = AnalysisResult(
        diagnosis: data['diagnosis'] ?? 'Unknown',
        description: data['description'] ?? '',
        confidence: (data['confidence'] ?? 0.0).toDouble(),
        severity: _parseSeverityLevel(data['severity']),
        riskLevel: _parseRiskLevel(data['risk_level']),
        recommendations:
            (data['recommendations'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        followUp: data['followUp']?.toString(),
        rawOutput: data,
        analysisDate: DateTime.now(),
      );

      // Create enhanced skin report using factory constructor
      final report = SkinReportEnhanced.fromAnalysisResult(
        imagePath: imagePath,
        analysisResult: analysis,
        notes: data['notes']?.toString(),
      );

      // Save using the repository directly
      final result = await reportRepository.saveReport(report);

      result.fold(
        (savedReport) async {
          // ✅ REAL-TIME HISTORY UPDATE: Add report to local state instantly
          // This ensures the history screen shows the new report immediately
          // without needing to restart the app or manually refresh
          historyVM.addReportToLocalState(savedReport);

          Get.snackbar(
            'Success',
            'Report saved to history',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        (error) {
          Get.snackbar(
            'Error',
            'Failed to save report: ${error.message}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save report: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  SeverityLevel? _parseSeverityLevel(dynamic severity) {
    if (severity == null) return null;
    final severityStr = severity.toString().toLowerCase();

    switch (severityStr) {
      case 'mild':
        return SeverityLevel.mild;
      case 'moderate':
        return SeverityLevel.moderate;
      case 'severe':
        return SeverityLevel.severe;
      case 'critical':
        return SeverityLevel.critical;
      default:
        return null;
    }
  }

  RiskLevel? _parseRiskLevel(dynamic riskLevel) {
    if (riskLevel == null) return null;
    final riskStr = riskLevel.toString().toLowerCase();

    switch (riskStr) {
      case 'low':
        return RiskLevel.low;
      case 'medium':
        return RiskLevel.medium;
      case 'high':
        return RiskLevel.high;
      case 'critical':
        return RiskLevel.critical;
      default:
        return null;
    }
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.cardBackground,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analyzed Image',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red, size: 48),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    final data = analysisResult['data'] as Map<String, dynamic>;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.cardBackground,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Analysis Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Diagnosis
          _buildResultRow('Diagnosis', data['diagnosis'] ?? 'Unknown'),
          const SizedBox(height: 12),

          // Confidence
          _buildResultRow(
            'Confidence',
            '${((data['confidence'] ?? 0.0) * 100).toStringAsFixed(1)}%',
          ),
          const SizedBox(height: 12),

          // Severity
          _buildResultRow('Severity', data['severity'] ?? 'Unknown'),
          const SizedBox(height: 12),

          // Risk Level
          _buildRiskLevel(data['risk_level'] ?? 'Unknown'),
          const SizedBox(height: 12),

          // Description
          if (data['description'] != null) ...[
            Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data['description'],
              style: TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    final data = analysisResult['data'] as Map<String, dynamic>;
    final recommendations = data['recommendations'] as List<dynamic>? ?? [];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.cardBackground,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          ...recommendations.map(
            (recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.primaryButton,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation.toString(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Follow-up
          if (data['followUp'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryButton.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: AppColors.primaryButton,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Follow-up: ${data['followUp']}',
                      style: TextStyle(
                        color: AppColors.primaryButton,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(value, style: TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildRiskLevel(String riskLevel) {
    Color riskColor;
    IconData riskIcon;

    switch (riskLevel.toLowerCase()) {
      case 'low':
        riskColor = Colors.green;
        riskIcon = Icons.check_circle;
        break;
      case 'moderate':
        riskColor = Colors.orange;
        riskIcon = Icons.warning;
        break;
      case 'high':
        riskColor = Colors.red;
        riskIcon = Icons.error;
        break;
      default:
        riskColor = Colors.grey;
        riskIcon = Icons.help;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Risk Level:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          children: [
            Icon(riskIcon, color: riskColor, size: 16),
            const SizedBox(width: 4),
            Text(
              riskLevel,
              style: TextStyle(color: riskColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Important Disclaimer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This AI analysis is for informational purposes only and should not replace professional medical advice. Please consult with a qualified dermatologist for proper diagnosis and treatment.',
            style: TextStyle(
              color: Colors.amber[800],
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement find dermatologist functionality
            },
            icon: const Icon(Icons.local_hospital, color: Colors.white),
            label: const Text(
              'Find Dermatologist',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryButton,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.back();
              Get.back(); // Go back to welcome screen
            },
            icon: Icon(Icons.home, color: AppColors.textPrimary),
            label: Text(
              'Back to Home',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryButton,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
