import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../model/skin_report.dart';

class HistoryController extends GetxController {
  static const String boxName = 'skin_reports';
  late Box<SkinReport> _box;
  var reports = <SkinReport>[].obs;

  @override
  void onInit() {
    super.onInit();
    _openBox();
  }

  Future<void> _openBox() async {
    _box = await Hive.openBox<SkinReport>(boxName);
    loadReports();
  }

  void loadReports() {
    reports.value = _box.values.toList().reversed.toList();
  }

  Future<void> addReport(SkinReport report) async {
    await _box.add(report);
    loadReports();
  }
}
