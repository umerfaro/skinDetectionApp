import 'package:get/get.dart';

class NavigationViewModel extends GetxController {
  // Current page index
  final RxInt _currentIndex = 0.obs;

  // Page history for back navigation
  final RxList<int> _pageHistory = <int>[].obs;

  // Getters
  int get currentIndex => _currentIndex.value;
  List<int> get pageHistory => _pageHistory.toList();

  // Available pages
  static const int homePageIndex = 0;
  static const int historyPageIndex = 1;

  bool get isOnHomePage => currentIndex == homePageIndex;
  bool get isOnHistoryPage => currentIndex == historyPageIndex;
  bool get canGoBack => _pageHistory.isNotEmpty;

  /// Change to specific page index
  void changeIndex(int index) {
    if (index == currentIndex) return;

    // Add current page to history before changing
    if (currentIndex != index) {
      _pageHistory.add(currentIndex);

      // Limit history size to prevent memory issues
      if (_pageHistory.length > 10) {
        _pageHistory.removeAt(0);
      }
    }

    _currentIndex.value = index;
  }

  /// Navigate to home page
  void navigateToHome() {
    changeIndex(homePageIndex);
  }

  /// Navigate to history page
  void navigateToHistory() {
    changeIndex(historyPageIndex);
  }

  /// Go back to previous page
  void goBack() {
    if (canGoBack) {
      final previousIndex = _pageHistory.removeLast();
      _currentIndex.value = previousIndex;
    }
  }

  /// Reset navigation to home
  void resetToHome() {
    _pageHistory.clear();
    _currentIndex.value = homePageIndex;
  }

  /// Clear navigation history
  void clearHistory() {
    _pageHistory.clear();
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize with home page
    _currentIndex.value = homePageIndex;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
