import 'package:hive/hive.dart';
import 'analysis_result.dart';

part 'skin_report_enhanced.g.dart';

@HiveType(typeId: 1)
class SkinReportEnhanced extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime? updatedAt;

  @HiveField(4)
  final String diagnosis;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final double? confidence;

  @HiveField(7)
  final String? severity;

  @HiveField(8)
  final List<String> recommendations;

  @HiveField(9)
  final String? riskLevel;

  @HiveField(10)
  final String? followUp;

  @HiveField(11)
  final Map<String, dynamic>? rawOutput;

  @HiveField(12)
  final bool isFavorite;

  @HiveField(13)
  final String? notes;

  SkinReportEnhanced({
    required this.id,
    required this.imagePath,
    required this.createdAt,
    this.updatedAt,
    required this.diagnosis,
    required this.description,
    this.confidence,
    this.severity,
    required this.recommendations,
    this.riskLevel,
    this.followUp,
    this.rawOutput,
    this.isFavorite = false,
    this.notes,
  });

  // Factory constructor from analysis result
  factory SkinReportEnhanced.fromAnalysisResult({
    required String imagePath,
    required AnalysisResult analysisResult,
    String? notes,
  }) {
    return SkinReportEnhanced(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
      createdAt: analysisResult.analysisDate,
      diagnosis: analysisResult.diagnosis,
      description: analysisResult.description,
      confidence: analysisResult.confidence,
      severity: analysisResult.severity?.value,
      recommendations: analysisResult.recommendations,
      riskLevel: analysisResult.riskLevel?.value,
      followUp: analysisResult.followUp,
      rawOutput: analysisResult.rawOutput,
      notes: notes,
    );
  }

  // Convert to analysis result
  AnalysisResult toAnalysisResult() {
    return AnalysisResult(
      diagnosis: diagnosis,
      confidence: confidence,
      severity: severity != null ? SeverityLevel.fromString(severity!) : null,
      recommendations: recommendations,
      description: description,
      riskLevel: riskLevel != null ? RiskLevel.fromString(riskLevel!) : null,
      followUp: followUp,
      rawOutput: rawOutput,
      analysisDate: createdAt,
    );
  }

  // Update report with new analysis
  SkinReportEnhanced updateWithAnalysis(AnalysisResult newAnalysis) {
    return SkinReportEnhanced(
      id: id,
      imagePath: imagePath,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      diagnosis: newAnalysis.diagnosis,
      description: newAnalysis.description,
      confidence: newAnalysis.confidence,
      severity: newAnalysis.severity?.value,
      recommendations: newAnalysis.recommendations,
      riskLevel: newAnalysis.riskLevel?.value,
      followUp: newAnalysis.followUp,
      rawOutput: newAnalysis.rawOutput,
      isFavorite: isFavorite,
      notes: notes,
    );
  }

  // Copy with method
  SkinReportEnhanced copyWith({
    String? imagePath,
    DateTime? updatedAt,
    String? diagnosis,
    String? description,
    double? confidence,
    String? severity,
    List<String>? recommendations,
    String? riskLevel,
    String? followUp,
    Map<String, dynamic>? rawOutput,
    bool? isFavorite,
    String? notes,
  }) {
    return SkinReportEnhanced(
      id: id,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      diagnosis: diagnosis ?? this.diagnosis,
      description: description ?? this.description,
      confidence: confidence ?? this.confidence,
      severity: severity ?? this.severity,
      recommendations: recommendations ?? this.recommendations,
      riskLevel: riskLevel ?? this.riskLevel,
      followUp: followUp ?? this.followUp,
      rawOutput: rawOutput ?? this.rawOutput,
      isFavorite: isFavorite ?? this.isFavorite,
      notes: notes ?? this.notes,
    );
  }

  // Validation methods
  bool get isValid => imagePath.isNotEmpty && diagnosis.isNotEmpty;

  bool get hasHighRisk =>
      riskLevel?.toLowerCase() == 'high' ||
      riskLevel?.toLowerCase() == 'critical';

  String get formattedDate =>
      '${createdAt.day}/${createdAt.month}/${createdAt.year}';

  String get riskLevelDisplay => riskLevel ?? 'Unknown';

  String get confidenceDisplay =>
      confidence != null ? '${(confidence! * 100).toStringAsFixed(1)}%' : 'N/A';

  @override
  String toString() {
    return 'SkinReportEnhanced(id: $id, diagnosis: $diagnosis, createdAt: $createdAt)';
  }
}
