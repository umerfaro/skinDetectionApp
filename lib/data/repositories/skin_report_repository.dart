import 'package:hive/hive.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import '../../core/results/result.dart';
import '../../models/skin_report_enhanced.dart';

abstract class ISkinReportRepository {
  Future<Result<List<SkinReportEnhanced>>> getAllReports();
  Future<Result<SkinReportEnhanced>> getReportById(String id);
  Future<Result<SkinReportEnhanced>> saveReport(SkinReportEnhanced report);
  Future<Result<SkinReportEnhanced>> updateReport(SkinReportEnhanced report);
  Future<Result<bool>> deleteReport(String id);
  Future<Result<List<SkinReportEnhanced>>> getFavoriteReports();
  Future<Result<List<SkinReportEnhanced>>> getReportsByDateRange(
    DateTime start,
    DateTime end,
  );
}

class SkinReportRepository implements ISkinReportRepository {
  static const String _boxName = 'skin_reports_enhanced';

  Box<SkinReportEnhanced>? _box;

  Future<Box<SkinReportEnhanced>> get box async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }

    try {
      _box = await Hive.openBox<SkinReportEnhanced>(_boxName);
      return _box!;
    } catch (e) {
      throw AppError.storage(
        message: 'Failed to open storage box',
        originalError: e,
      );
    }
  }

  @override
  Future<Result<List<SkinReportEnhanced>>> getAllReports() async {
    try {
      final reportBox = await box;
      final reports = reportBox.values.toList();

      // Sort by creation date (newest first)
      reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Success(reports);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  @override
  Future<Result<SkinReportEnhanced>> getReportById(String id) async {
    try {
      final reportBox = await box;
      final report = reportBox.values.firstWhere(
        (report) => report.id == id,
        orElse: () =>
            throw AppError.validation(message: 'Report not found with id: $id'),
      );

      return Success(report);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  @override
  Future<Result<SkinReportEnhanced>> saveReport(
    SkinReportEnhanced report,
  ) async {
    try {
      if (!report.isValid) {
        return Failure(AppError.validation(message: 'Invalid report data'));
      }

      final reportBox = await box;
      await reportBox.add(report);

      return Success(report);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  @override
  Future<Result<SkinReportEnhanced>> updateReport(
    SkinReportEnhanced report,
  ) async {
    try {
      if (!report.isValid) {
        return Failure(AppError.validation(message: 'Invalid report data'));
      }

      final reportBox = await box;

      // Find existing report
      final existingIndex = reportBox.values.toList().indexWhere(
        (existingReport) => existingReport.id == report.id,
      );

      if (existingIndex == -1) {
        return Failure(
          AppError.validation(message: 'Report not found for update'),
        );
      }

      // Update the report
      await reportBox.putAt(existingIndex, report);

      return Success(report);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  @override
  Future<Result<bool>> deleteReport(String id) async {
    try {
      final reportBox = await box;

      // Find and remove report
      final reportToDelete = reportBox.values.firstWhere(
        (report) => report.id == id,
        orElse: () =>
            throw AppError.validation(message: 'Report not found for deletion'),
      );

      await reportToDelete.delete();

      return const Success(true);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  @override
  Future<Result<List<SkinReportEnhanced>>> getFavoriteReports() async {
    try {
      final reportBox = await box;
      final favoriteReports = reportBox.values
          .where((report) => report.isFavorite)
          .toList();

      // Sort by creation date (newest first)
      favoriteReports.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Success(favoriteReports);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  @override
  Future<Result<List<SkinReportEnhanced>>> getReportsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final reportBox = await box;
      final filteredReports = reportBox.values
          .where(
            (report) =>
                report.createdAt.isAfter(start) &&
                report.createdAt.isBefore(end),
          )
          .toList();

      // Sort by creation date (newest first)
      filteredReports.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Success(filteredReports);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  // Utility methods
  Future<Result<int>> getReportsCount() async {
    try {
      final reportBox = await box;
      return Success(reportBox.length);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }

  Future<Result<bool>> clearAllReports() async {
    try {
      final reportBox = await box;
      await reportBox.clear();
      return const Success(true);
    } catch (e, stackTrace) {
      final error = ErrorHandler.parseException(e, stackTrace);
      return Failure(error);
    }
  }
}
