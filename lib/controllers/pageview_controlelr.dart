// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class PageVController extends GetxController {
  RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  set currentIndex(int newIndex) {
    _currentIndex.value = newIndex;
    update();
  }
}
