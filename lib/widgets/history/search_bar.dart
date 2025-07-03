import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodels/skin_report_history_viewmodel.dart';

class ReportsSearchBar extends StatefulWidget {
  const ReportsSearchBar({super.key});

  @override
  State<ReportsSearchBar> createState() => _ReportsSearchBarState();
}

class _ReportsSearchBarState extends State<ReportsSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final historyVM = Get.find<SkinReportHistoryViewModel>();
    _controller.text = historyVM.searchQuery;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyVM = Get.find<SkinReportHistoryViewModel>();

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Search reports...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Obx(() {
          return historyVM.searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _controller.clear();
                    historyVM.updateSearchQuery('');
                    _focusNode.unfocus();
                  },
                  icon: const Icon(Icons.clear),
                )
              : const SizedBox.shrink();
        }),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onChanged: (value) {
        historyVM.updateSearchQuery(value);
      },
      onSubmitted: (value) {
        _focusNode.unfocus();
      },
    );
  }
}
