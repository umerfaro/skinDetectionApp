import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'ui/Home/home.dart';
import 'consts/consts.dart';
import 'model/skin_report.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SkinReportAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Define your light and dark themes (unchanged except formatting)
  final ThemeData lightTheme = ThemeData(
    // The brightness of the theme.
    brightness: Brightness.dark,
    // The primary color of the theme.
    primaryColor: AppColors.darkGreen,
    // The background color of the scaffold.
    scaffoldBackgroundColor: AppColors.background,
    // The font family of the theme.
    fontFamily: 'Inter',
    // The text theme of the application.
    textTheme: const TextTheme(
      // The style for the body text.
      bodyLarge: TextStyle(color: AppColors.textSecondary),
      // The style for the body text.
      bodyMedium: TextStyle(color: AppColors.textSecondary),
      // The style for the headline text.
      headlineMedium: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    // The brightness of the theme.
    brightness: Brightness.dark,
    // The primary color of the theme.
    primaryColor: AppColors.darkGreen,
    // The background color of the scaffold.
    scaffoldBackgroundColor: AppColors.background,
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const Home(),
    );
  }
}
