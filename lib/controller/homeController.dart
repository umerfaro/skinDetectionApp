import 'package:flutter/foundation.dart';
import '../consts/consts.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
