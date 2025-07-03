import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../models/skin_report_enhanced.dart';
import '../../viewmodels/skin_report_history_viewmodel.dart';
import 'report_item.dart';

class ReportsList extends StatelessWidget {
  final List<SkinReportEnhanced> reports;

  const ReportsList({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final historyVM = Get.find<SkinReportHistoryViewModel>();

    return RefreshIndicator(
      onRefresh: historyVM.refreshReports,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ReportItem(
              report: report,
              onTap: () => _showReportDetails(context, report),
              onToggleFavorite: () => historyVM.toggleFavorite(report),
              onDelete: () =>
                  _showDeleteConfirmation(context, report, historyVM),
            ),
          );
        },
      ),
    );
  }

  void _showReportDetails(BuildContext context, SkinReportEnhanced report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Report Details',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Image
                if (File(report.imagePath).existsSync())
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(report.imagePath),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),

                // Diagnosis
                _buildDetailRow('Diagnosis', report.diagnosis),
                _buildDetailRow('Date', report.formattedDate),
                _buildDetailRow('Confidence', report.confidenceDisplay),
                _buildDetailRow('Risk Level', report.riskLevelDisplay),

                if (report.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],

                if (report.recommendations.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Recommendations',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...report.recommendations.map(
                    (recommendation) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(
                            child: Text(
                              recommendation,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (report.notes?.isNotEmpty == true) ...[
                  const SizedBox(height: 16),
                  Text('Notes', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    report.notes!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    SkinReportEnhanced report,
    SkinReportHistoryViewModel historyVM,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text(
          'Are you sure you want to delete this report? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              historyVM.deleteReport(report.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
