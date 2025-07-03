import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/skin_report_history_viewmodel.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/history/reports_list.dart';
import '../widgets/history/filter_bar.dart';
import '../widgets/history/search_bar.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final historyVM = Get.find<SkinReportHistoryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(
            () => Chip(
              label: Text('${historyVM.reportsCount}'),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ReportsSearchBar(),
          ),
          const SizedBox(height: 8),

          // Filter bar
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ReportsFilterBar(),
          ),
          const SizedBox(height: 16),

          // Reports list with pull-to-refresh
          Expanded(
            child: Obx(() {
              final state = historyVM.reportsState;

              if (state.isLoading) {
                return const LoadingWidget(message: 'Loading reports...');
              }

              if (state.isError) {
                return ErrorStateWidget(
                  message: state.errorMessage ?? 'Failed to load reports',
                  onRetry: historyVM.loadReports,
                );
              }

              final filteredReports = historyVM.filteredReports;

              if (filteredReports.isEmpty) {
                return RefreshIndicator(
                  onRefresh: historyVM.refreshReports,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: EmptyStateWidget(
                        icon: Icons.history,
                        title: historyVM.searchQuery.isNotEmpty
                            ? 'No matching reports'
                            : 'No reports yet',
                        subtitle: historyVM.searchQuery.isNotEmpty
                            ? 'Try adjusting your search or filters'
                            : 'Start by analyzing your first skin image',
                        actionLabel: historyVM.searchQuery.isNotEmpty
                            ? 'Clear filters'
                            : null,
                        onAction: historyVM.searchQuery.isNotEmpty
                            ? historyVM.clearFilters
                            : null,
                      ),
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: historyVM.refreshReports,
                child: ReportsList(reports: filteredReports),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        return historyVM.reportsCount > 0
            ? FloatingActionButton(
                onPressed: () => _showStatsDialog(context, historyVM),
                child: const Icon(Icons.analytics),
                tooltip: 'View Statistics',
              )
            : const SizedBox.shrink();
      }),
    );
  }

  void _showStatsDialog(
    BuildContext context,
    SkinReportHistoryViewModel historyVM,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow('Total Reports', '${historyVM.reportsCount}'),
            _buildStatRow('Favorites', '${historyVM.favoritesCount}'),
            _buildStatRow('High Risk', '${historyVM.highRiskCount}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
