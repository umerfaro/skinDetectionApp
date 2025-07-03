import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodels/skin_report_history_viewmodel.dart';

class ReportsFilterBar extends StatelessWidget {
  const ReportsFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final historyVM = Get.find<SkinReportHistoryViewModel>();

    return Row(
      children: [
        // Filter dropdown
        Expanded(
          flex: 2,
          child: Obx(
            () => DropdownButtonFormField<SkinReportFilter>(
              value: historyVM.currentFilter,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Filter',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              items: SkinReportFilter.values.map((filter) {
                return DropdownMenuItem(
                  value: filter,
                  child: Text(
                    _getShortDisplayName(filter),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (filter) {
                if (filter != null) {
                  historyVM.updateFilter(filter);
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Sort dropdown
        Expanded(
          flex: 2,
          child: Obx(
            () => DropdownButtonFormField<SortOrder>(
              value: historyVM.sortOrder,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Sort',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              items: SortOrder.values.map((order) {
                return DropdownMenuItem(
                  value: order,
                  child: Text(
                    _getShortSortName(order),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (order) {
                if (order != null) {
                  historyVM.updateSortOrder(order);
                }
              },
            ),
          ),
        ),

        // Clear filters button
        Obx(() {
          final hasActiveFilters =
              historyVM.searchQuery.isNotEmpty ||
              historyVM.currentFilter != SkinReportFilter.all ||
              historyVM.sortOrder != SortOrder.newest;

          return hasActiveFilters
              ? IconButton(
                  onPressed: historyVM.clearFilters,
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Clear all filters',
                )
              : const SizedBox(width: 48);
        }),
      ],
    );
  }

  String _getShortDisplayName(SkinReportFilter filter) {
    switch (filter) {
      case SkinReportFilter.all:
        return 'All';
      case SkinReportFilter.favorites:
        return 'Favorites';
      case SkinReportFilter.highRisk:
        return 'High Risk';
      case SkinReportFilter.recent:
        return 'Recent';
    }
  }

  String _getShortSortName(SortOrder order) {
    switch (order) {
      case SortOrder.newest:
        return 'Newest';
      case SortOrder.oldest:
        return 'Oldest';
      case SortOrder.riskLevel:
        return 'Risk Level';
      case SortOrder.diagnosis:
        return 'A-Z';
    }
  }
}
