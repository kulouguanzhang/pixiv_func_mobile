import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController();

  int _index = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
    update();
  }
}
