
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_func_android/app/http/http.dart';
import 'package:pixiv_func_android/app/inject/inject.dart';
import 'package:pixiv_func_android/app/theme/app_theme.dart';
import 'package:pixiv_func_android/pages/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Inject.init();
  HttpConfig.refreshHttpClient();
  runApp(
    GetMaterialApp(
      title: 'Pixiv Func',
      home: const HomeWidget(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      enableLog: false,
    ),
  );

  final storageStatus = Permission.storage;

  if (!await storageStatus.isGranted) {
    Permission.storage.request();
  }
}
