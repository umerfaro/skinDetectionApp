import 'consts.dart';

class Utils {
  static void fieldFocus(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void showSnackBar({
    required String title,
    required String message,
    Color backgroundColor = AppColors.white,
    Color textColor = Colors.black,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor.withValues(alpha: 204),
      colorText: textColor,
    );
  }
}
