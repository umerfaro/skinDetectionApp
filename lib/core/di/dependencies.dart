import 'package:get/get.dart';
import '../../data/repositories/image_repository.dart';
import '../../data/repositories/skin_analysis_repository.dart';
import '../../data/repositories/skin_report_repository.dart';
import '../../viewmodels/image_capture_viewmodel.dart';
import '../../viewmodels/navigation_viewmodel.dart';
import '../../viewmodels/skin_analysis_viewmodel.dart';
import '../../viewmodels/skin_report_history_viewmodel.dart';

class Dependencies {
  static void initialize() {
    // Initialize repositories
    _initializeRepositories();

    // Initialize view models
    _initializeViewModels();
  }

  static void _initializeRepositories() {
    // Register repository implementations
    Get.put<IImageRepository>(ImageRepository(), permanent: true);
    Get.put<ISkinAnalysisRepository>(SkinAnalysisRepository(), permanent: true);
    Get.put<ISkinReportRepository>(SkinReportRepository(), permanent: true);
  }

  static void _initializeViewModels() {
    // Register view models with their dependencies
    Get.put(NavigationViewModel(), permanent: true);

    Get.put(
      ImageCaptureViewModel(Get.find<IImageRepository>()),
      permanent: true,
    );

    Get.put(
      SkinAnalysisViewModel(
        Get.find<ISkinAnalysisRepository>(),
        Get.find<ISkinReportRepository>(),
      ),
      permanent: true,
    );

    Get.put(
      SkinReportHistoryViewModel(Get.find<ISkinReportRepository>()),
      permanent: true,
    );
  }

  static void dispose() {
    // Clean up resources if needed
    Get.reset();
  }
}
