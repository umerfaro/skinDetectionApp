import '../../consts/consts.dart';

import '../../controller/homeController.dart';
import '../../WidgetCommons/exist_dialog.dart';
import '../History/history.dart';
import '../WelcomeScreen/welcomScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    // Updated NavBar Items using Icons from the Flutter Icons library
    var naveBarItem = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home), // Unselected state

        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.list_alt), // Unselected state
        label: 'history',
      ),
    ];

    // Navigation body that corresponds to each item
    var navBody = [const WelcomeScreen(), const HistoryScreen()];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }

          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => exitDialogWidget(context),
          );
        },
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => navBody.elementAt(controller.currentIndex.value),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          selectedItemColor:
              AppColors.textOnPrimaryButton, // Color for selected item
          selectedIconTheme: IconThemeData(
            size: 30,
            color: AppColors.textOnPrimaryButton,
          ), // Size of selected icon
          unselectedItemColor:
              Colors.grey[500], // Unselected items color (light pink)
          backgroundColor: Theme.of(
            context,
          ).scaffoldBackgroundColor, // Navigation background color (white)
          type: BottomNavigationBarType.fixed, // Ensure all items are displayed
          showSelectedLabels:
              true, // Hide labels for active icons (per the image)
          showUnselectedLabels: true, // Hide labels for inactive icons
          items: naveBarItem, // Custom items defined above
          onTap: (index) {
            controller.changeIndex(index); // Change the selected index
          },
        ),
      ),
    );
  }
}
