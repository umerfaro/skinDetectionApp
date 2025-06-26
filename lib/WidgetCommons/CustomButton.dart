import "../consts/consts.dart"; // Ensure you have the proper imports for images and other assets.
import "../consts/colors.dart";

Widget customButtonWidget({
  onPress,
  String? title,
  textColor,
  color,
  bool loading = false,
  String? imagePath, // New parameter for the image path
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: color,
      padding: const EdgeInsets.all(15),
    ),
    onPressed: loading ? null : onPress,
    child: loading
        ? RepaintBoundary(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.white),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              if (imagePath != null)
                Positioned(
                  left: 0, // Place the image on the left
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      4,
                    ), // Make the image rounded (half of the image width/height for full circular)
                    child: Image.asset(
                      imagePath, // Use Image.network() if it's an online resource
                      width: 24, // Adjust the size of the logo
                      height: 28,
                      fit: BoxFit
                          .cover, // Ensure the image covers the entire area
                    ),
                  ),
                ),
              Center(
                child: title!.text
                    .color(textColor)
                    .fontFamily(bold)
                    .make(), // Keep the title centered
              ),
            ],
          ),
  );
}
