// Analysis result model for skin analysis
class AnalysisResult {
  final String diagnosis;
  final double? confidence;
  final SeverityLevel? severity;
  final List<String> recommendations;
  final String description;
  final RiskLevel? riskLevel;
  final String? followUp;
  final Map<String, dynamic>? rawOutput;
  final DateTime analysisDate;

  const AnalysisResult({
    required this.diagnosis,
    this.confidence,
    this.severity,
    required this.recommendations,
    required this.description,
    this.riskLevel,
    this.followUp,
    this.rawOutput,
    required this.analysisDate,
  });

  factory AnalysisResult.fromMap(Map<String, dynamic> map) {
    // Handle raw_output with proper type checking
    Map<String, dynamic>? rawOutput;
    final rawOutputValue = map['raw_output'];
    if (rawOutputValue is Map<String, dynamic>) {
      rawOutput = rawOutputValue;
    } else if (rawOutputValue is List<dynamic>) {
      // Convert List to Map structure
      rawOutput = {
        'original_output': rawOutputValue,
        'type': 'list_tokens',
        'processed_text': rawOutputValue.join('').trim(),
      };
    } else if (rawOutputValue != null) {
      // Convert other types to Map structure
      rawOutput = {
        'original_output': rawOutputValue,
        'type': rawOutputValue.runtimeType.toString(),
        'processed_text': rawOutputValue.toString(),
      };
    }

    return AnalysisResult(
      diagnosis: map['diagnosis'] ?? 'Unknown',
      confidence: map['confidence']?.toDouble(),
      severity: map['severity'] != null
          ? SeverityLevel.fromString(map['severity'])
          : null,
      recommendations: List<String>.from(map['recommendations'] ?? []),
      description: map['description'] ?? '',
      riskLevel: map['risk_level'] != null
          ? RiskLevel.fromString(map['risk_level'])
          : null,
      followUp: map['followUp'],
      rawOutput: rawOutput,
      analysisDate: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'diagnosis': diagnosis,
      'confidence': confidence,
      'severity': severity?.value,
      'recommendations': recommendations,
      'description': description,
      'risk_level': riskLevel?.value,
      'followUp': followUp,
      'raw_output': rawOutput,
      'analysis_date': analysisDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'AnalysisResult(diagnosis: $diagnosis, confidence: $confidence, severity: $severity)';
  }
}

// Severity level enumeration
enum SeverityLevel {
  mild('Mild'),
  moderate('Moderate'),
  severe('Severe'),
  critical('Critical');

  const SeverityLevel(this.value);
  final String value;

  static SeverityLevel? fromString(String value) {
    try {
      return SeverityLevel.values.firstWhere(
        (level) => level.value.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}

// Risk level enumeration
enum RiskLevel {
  low('Low'),
  medium('Medium'),
  high('High'),
  critical('Critical');

  const RiskLevel(this.value);
  final String value;

  static RiskLevel? fromString(String value) {
    try {
      return RiskLevel.values.firstWhere(
        (level) => level.value.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
