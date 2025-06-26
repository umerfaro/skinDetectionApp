import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/colors.dart';
import '../../controller/history_controller.dart';
import '../../model/skin_report.dart';
import 'dart:io';

// --- Mock Data Model ---
// Represents a single scan history item.
class ScanHistoryItem {
  final String imageUrl;
  final String date;
  final String diagnosis;

  const ScanHistoryItem({
    required this.imageUrl,
    required this.date,
    required this.diagnosis,
  });
}

// --- History Screen ---
// This screen displays the list of past skin scans.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyController = Get.put(HistoryController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (historyController.reports.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 80, color: AppColors.textSecondary),
                SizedBox(height: 20),
                Text(
                  'No History Available',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your analysis history will appear here once you start using the app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: historyController.reports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final report = historyController.reports[index];
            return _buildReportCard(report);
          },
        );
      }),
    );
  }

  Widget _buildReportCard(SkinReport report) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.cardBackground,
      child: ListTile(
        leading: Image.file(
          File(report.imagePath),
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image, size: 40),
        ),
        title: Text(
          report.diagnosis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          report.date.split('T').first,
          style: const TextStyle(color: AppColors.textOnPrimaryButton),
        ),
        onTap: () {
          // Optionally, show full report details
          Get.defaultDialog(
            title: 'Report Details',
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Diagnosis: ${report.diagnosis}'),
                  const SizedBox(height: 8),
                  Text('Date: ${report.date}'),
                  const SizedBox(height: 8),
                  Text('Description:'),
                  Text(report.description),
                ],
              ),
            ),
            textConfirm: 'Close',
            confirmTextColor: Colors.white,
            onConfirm: () => Get.back(),
          );
        },
      ),
    );
  }
}
