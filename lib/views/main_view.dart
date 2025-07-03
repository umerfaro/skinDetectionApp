import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../consts/colors.dart';
import '../viewmodels/navigation_viewmodel.dart';

import 'home_view.dart';
import 'history_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationVM = Get.find<NavigationViewModel>();

    // Navigation bar items
    final navBarItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(
        icon: Icon(Icons.list_alt),
        label: 'History',
      ),
    ];

    // Navigation body that corresponds to each item
    final navBody = [const HomeView(), const HistoryView()];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
        },
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: navigationVM.currentIndex,
                  children: navBody,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navigationVM.currentIndex,
          selectedItemColor: AppColors.textOnPrimaryButton,
          selectedIconTheme: const IconThemeData(
            size: 30,
            color: AppColors.textOnPrimaryButton,
          ),
          unselectedItemColor: Colors.grey[500],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: navBarItems,
          onTap: navigationVM.changeIndex,
        ),
      ),
    );
  }
}
