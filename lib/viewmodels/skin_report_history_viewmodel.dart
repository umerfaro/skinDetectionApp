import 'package:get/get.dart';
import '../core/errors/error_handler.dart';
import '../core/results/result.dart';
import '../core/state/view_state.dart';
import '../data/repositories/skin_report_repository.dart';
import '../models/skin_report_enhanced.dart';

class SkinReportHistoryViewModel extends GetxController {
  final ISkinReportRepository _reportRepository;

  SkinReportHistoryViewModel(this._reportRepository);

  // Observable states
  final Rx<ViewStateWrapper<List<SkinReportEnhanced>>> _reportsState =
      ViewStateWrapper<List<SkinReportEnhanced>>.idle().obs;
  final Rx<ViewStateWrapper<bool>> _deleteState =
      ViewStateWrapper<bool>.idle().obs;
  final Rx<ViewStateWrapper<List<SkinReportEnhanced>>> _favoritesState =
      ViewStateWrapper<List<SkinReportEnhanced>>.idle().obs;

  // Filter and search state
  final RxString _searchQuery = ''.obs;
  final Rx<SkinReportFilter> _currentFilter = SkinReportFilter.all.obs;
  final Rx<SortOrder> _sortOrder = SortOrder.newest.obs;

  // Getters
  ViewStateWrapper<List<SkinReportEnhanced>> get reportsState =>
      _reportsState.value;
  ViewStateWrapper<bool> get deleteState => _deleteState.value;
  ViewStateWrapper<List<SkinReportEnhanced>> get favoritesState =>
      _favoritesState.value;

  String get searchQuery => _searchQuery.value;
  SkinReportFilter get currentFilter => _currentFilter.value;
  SortOrder get sortOrder => _sortOrder.value;

  bool get isLoadingReports => reportsState.isLoading;
  bool get isDeleting => deleteState.isLoading;
  bool get isLoadingFavorites => favoritesState.isLoading;

  List<SkinReportEnhanced> get reports => reportsState.data ?? [];
  List<SkinReportEnhanced> get favorites => favoritesState.data ?? [];

  // Filtered and sorted reports
  List<SkinReportEnhanced> get filteredReports {
    var reportList = reports;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      reportList = reportList.where((report) {
        return report.diagnosis.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            report.description.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            (report.notes?.toLowerCase().contains(searchQuery.toLowerCase()) ??
                false);
      }).toList();
    }

    // Apply category filter
    switch (currentFilter) {
      case SkinReportFilter.favorites:
        reportList = reportList.where((report) => report.isFavorite).toList();
        break;
      case SkinReportFilter.highRisk:
        reportList = reportList.where((report) => report.hasHighRisk).toList();
        break;
      case SkinReportFilter.recent:
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
        reportList = reportList
            .where((report) => report.createdAt.isAfter(thirtyDaysAgo))
            .toList();
        break;
      case SkinReportFilter.all:
      default:
        break;
    }

    // Apply sorting
    switch (sortOrder) {
      case SortOrder.newest:
        reportList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOrder.oldest:
        reportList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOrder.riskLevel:
        reportList.sort((a, b) => _compareRiskLevel(a, b));
        break;
      case SortOrder.diagnosis:
        reportList.sort((a, b) => a.diagnosis.compareTo(b.diagnosis));
        break;
    }

    return reportList;
  }

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  /// Load all reports
  Future<void> loadReports() async {
    _reportsState.value = ViewStateWrapper.loading(LoadingType.initial);

    try {
      final result = await _reportRepository.getAllReports();

      result.fold(
        (reports) {
          _reportsState.value = ViewStateWrapper.success(reports);
        },
        (error) {
          _reportsState.value = ViewStateWrapper.error(error.message);
          ErrorHandler.handleError(error);
        },
      );
    } catch (e) {
      final error = ErrorHandler.parseException(e);
      _reportsState.value = ViewStateWrapper.error(error.message);
      ErrorHandler.handleError(error);
    }
  }

  /// Refresh reports
  Future<void> refreshReports() async {
    _reportsState.value = ViewStateWrapper.loading(LoadingType.refresh);
    await loadReports();
  }

  /// Delete a report
  Future<void> deleteReport(String reportId) async {
    _deleteState.value = ViewStateWrapper.loading(LoadingType.action);

    try {
      final result = await _reportRepository.deleteReport(reportId);

      result.fold(
        (success) {
          _deleteState.value = ViewStateWrapper.success(success);

          // Remove from local list
          final currentReports = reports
              .where((report) => report.id != reportId)
              .toList();
          _reportsState.value = ViewStateWrapper.success(currentReports);

          Get.snackbar(
            'Success',
            'Report deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (error) {
          _deleteState.value = ViewStateWrapper.error(error.message);
          ErrorHandler.handleError(error);
        },
      );
    } catch (e) {
      final error = ErrorHandler.parseException(e);
      _deleteState.value = ViewStateWrapper.error(error.message);
      ErrorHandler.handleError(error);
    }
  }

  /// Toggle favorite status of a report
  Future<void> toggleFavorite(SkinReportEnhanced report) async {
    try {
      final updatedReport = report.copyWith(isFavorite: !report.isFavorite);
      final result = await _reportRepository.updateReport(updatedReport);

      result.fold(
        (savedReport) {
          // Update local list
          final updatedReports = reports
              .map((r) => r.id == report.id ? savedReport : r)
              .toList();
          _reportsState.value = ViewStateWrapper.success(updatedReports);

          final action = savedReport.isFavorite ? 'added to' : 'removed from';
          Get.snackbar(
            'Success',
            'Report $action favorites',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (error) {
          ErrorHandler.handleError(error);
        },
      );
    } catch (e) {
      final error = ErrorHandler.parseException(e);
      ErrorHandler.handleError(error);
    }
  }

  /// Load favorite reports
  Future<void> loadFavorites() async {
    _favoritesState.value = ViewStateWrapper.loading(LoadingType.initial);

    try {
      final result = await _reportRepository.getFavoriteReports();

      result.fold(
        (favorites) {
          _favoritesState.value = ViewStateWrapper.success(favorites);
        },
        (error) {
          _favoritesState.value = ViewStateWrapper.error(error.message);
          ErrorHandler.handleError(error);
        },
      );
    } catch (e) {
      final error = ErrorHandler.parseException(e);
      _favoritesState.value = ViewStateWrapper.error(error.message);
      ErrorHandler.handleError(error);
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  /// Update filter
  void updateFilter(SkinReportFilter filter) {
    _currentFilter.value = filter;
  }

  /// Update sort order
  void updateSortOrder(SortOrder order) {
    _sortOrder.value = order;
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery.value = '';
    _currentFilter.value = SkinReportFilter.all;
    _sortOrder.value = SortOrder.newest;
  }

  /// Add a new report to the local state instantly (for real-time updates)
  void addReportToLocalState(SkinReportEnhanced newReport) {
    final currentReports = List<SkinReportEnhanced>.from(reports);
    currentReports.insert(0, newReport); // Add at the beginning (newest first)
    _reportsState.value = ViewStateWrapper.success(currentReports);
  }

  /// Get reports count
  int get reportsCount => reports.length;
  int get favoritesCount => reports.where((report) => report.isFavorite).length;
  int get highRiskCount => reports.where((report) => report.hasHighRisk).length;

  /// Private helper methods
  int _compareRiskLevel(SkinReportEnhanced a, SkinReportEnhanced b) {
    final aRisk = _getRiskLevelPriority(a.riskLevel);
    final bRisk = _getRiskLevelPriority(b.riskLevel);
    return bRisk.compareTo(aRisk); // Higher risk first
  }

  int _getRiskLevelPriority(String? riskLevel) {
    switch (riskLevel?.toLowerCase()) {
      case 'critical':
        return 4;
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

// Enums for filtering and sorting
enum SkinReportFilter { all, favorites, highRisk, recent }

enum SortOrder { newest, oldest, riskLevel, diagnosis }

extension SkinReportFilterExtension on SkinReportFilter {
  String get displayName {
    switch (this) {
      case SkinReportFilter.all:
        return 'All Reports';
      case SkinReportFilter.favorites:
        return 'Favorites';
      case SkinReportFilter.highRisk:
        return 'High Risk';
      case SkinReportFilter.recent:
        return 'Recent (30 days)';
    }
  }
}

extension SortOrderExtension on SortOrder {
  String get displayName {
    switch (this) {
      case SortOrder.newest:
        return 'Newest First';
      case SortOrder.oldest:
        return 'Oldest First';
      case SortOrder.riskLevel:
        return 'Risk Level';
      case SortOrder.diagnosis:
        return 'Diagnosis A-Z';
    }
  }
}
