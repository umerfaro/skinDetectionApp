import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_error.dart';

class ErrorHandler {
  static void handleError(AppError error) {
    // Log error based on severity
    _logError(error);

    // Show user-friendly message
    _showUserMessage(error);
  }

  static AppError parseException(dynamic exception, [StackTrace? stackTrace]) {
    if (exception is SocketException) {
      return AppError.network(
        message:
            'No internet connection. Please check your network and try again.',
        originalError: exception,
        stackTrace: stackTrace,
      );
    }

    if (exception is HttpException) {
      return AppError.server(
        message: 'Server error occurred. Please try again later.',
        originalError: exception,
        stackTrace: stackTrace,
      );
    }

    if (exception is FormatException) {
      return AppError.validation(
        message: 'Invalid data format received.',
        originalError: exception,
        stackTrace: stackTrace,
      );
    }

    // Default unknown error
    return AppError.unknown(
      message: exception.toString(),
      originalError: exception,
      stackTrace: stackTrace,
    );
  }

  static void _logError(AppError error) {
    switch (error.severity) {
      case ErrorSeverity.low:
        debugPrint('INFO: ${error.message}');
        break;
      case ErrorSeverity.medium:
        debugPrint('WARNING: ${error.message}');
        break;
      case ErrorSeverity.high:
      case ErrorSeverity.critical:
        debugPrint('ERROR: ${error.message}');
        if (error.stackTrace != null) {
          debugPrint('Stack trace: ${error.stackTrace}');
        }
        break;
    }
  }

  static void _showUserMessage(AppError error) {
    // Only show user messages for certain error types and severities
    if (error.severity == ErrorSeverity.low &&
        error.type == ErrorType.validation) {
      return; // Don't show snackbar for minor validation errors
    }

    String title = _getErrorTitle(error.type);
    Color backgroundColor = _getErrorColor(error.severity);

    Get.snackbar(
      title,
      error.message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: Duration(seconds: _getDisplayDuration(error.severity)),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      snackPosition: SnackPosition.TOP,
    );
  }

  static String _getErrorTitle(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return 'Connection Error';
      case ErrorType.server:
        return 'Server Error';
      case ErrorType.validation:
        return 'Validation Error';
      case ErrorType.permission:
        return 'Permission Denied';
      case ErrorType.storage:
        return 'Storage Error';
      case ErrorType.imageProcessing:
        return 'Image Processing Error';
      case ErrorType.authentication:
        return 'Authentication Error';
      case ErrorType.unknown:
        return 'Error';
    }
  }

  static Color _getErrorColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return Colors.blue;
      case ErrorSeverity.medium:
        return Colors.orange;
      case ErrorSeverity.high:
        return Colors.red;
      case ErrorSeverity.critical:
        return Colors.red.shade800;
    }
  }

  static int _getDisplayDuration(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return 2;
      case ErrorSeverity.medium:
        return 3;
      case ErrorSeverity.high:
        return 4;
      case ErrorSeverity.critical:
        return 5;
    }
  }
}
