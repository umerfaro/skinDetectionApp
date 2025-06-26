import 'package:flutter/services.dart';

import "../consts/consts.dart";
import 'CustomButton.dart';

Widget exitDialogWidget(BuildContext context) {
  return Dialog(
    child:
        Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                "Confirm Exit".text
                    .color(AppColors.textOnPrimaryButton)
                    .size(18)
                    .fontFamily(bold)
                    .make(),
                const Divider(),
                10.heightBox,
                "Are you sure you want to exit?".text
                    .color(AppColors.textOnPrimaryButton)
                    .size(16)
                    .make(),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customButtonWidget(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      title: "No",
                      textColor: AppColors.white,
                      color: AppColors.primaryButton,
                    ),
                    customButtonWidget(
                      onPress: () {
                        SystemNavigator.pop();
                      },
                      title: "Yes",
                      textColor: AppColors.white,
                      color: AppColors.primaryButton,
                    ),
                  ],
                ),
              ],
            ).box
            .color(AppColors.white)
            .padding(const EdgeInsets.all(12))
            .roundedSM
            .make(),
  );
}
