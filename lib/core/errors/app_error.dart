// Core error types enumeration
enum ErrorType {
  network,
  server,
  validation,
  permission,
  storage,
  imageProcessing,
  authentication,
  unknown,
}

// Error severity levels
enum ErrorSeverity { low, medium, high, critical }

// Generic application error class
class AppError {
  final ErrorType type;
  final ErrorSeverity severity;
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppError({
    required this.type,
    required this.severity,
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  // Factory constructors for common error types
  factory AppError.network({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return AppError(
      type: ErrorType.network,
      severity: ErrorSeverity.medium,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  factory AppError.server({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return AppError(
      type: ErrorType.server,
      severity: ErrorSeverity.high,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  factory AppError.validation({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return AppError(
      type: ErrorType.validation,
      severity: ErrorSeverity.low,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  factory AppError.permission({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return AppError(
      type: ErrorType.permission,
      severity: ErrorSeverity.medium,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  factory AppError.storage({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return AppError(
      type: ErrorType.storage,
      severity: ErrorSeverity.medium,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  factory AppError.imageProcessing({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return AppError(
      type: ErrorType.imageProcessing,
      severity: ErrorSeverity.medium,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  factory AppError.unknown({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return AppError(
      type: ErrorType.unknown,
      severity: ErrorSeverity.medium,
      message: message,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() {
    return 'AppError(type: $type, severity: $severity, message: $message, code: $code)';
  }
}
