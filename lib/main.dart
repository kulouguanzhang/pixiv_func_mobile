import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_func_mobile/app/http/http.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n_translations.dart';
import 'package:pixiv_func_mobile/app/inject/inject.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/route/route.dart';
import 'package:pixiv_func_mobile/app/settings/app_settings.dart';
import 'package:pixiv_func_mobile/app/theme/app_theme.dart';
import 'package:pixiv_func_mobile/pages/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Inject.init();
  HttpConfig.refreshHttpClient();

  runApp(const App());

  final storageStatus = Permission.storage;

  if (!await storageStatus.isGranted) {
    Permission.storage.request();
  }
}

DateTime? _lastPopTime;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeCodes = Get.find<AppSettingsService>().language.split('-');

    return GetMaterialApp(
      translations: I18nTranslations(),
      locale: Locale(localeCodes.first, localeCodes.last),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
        Locale('ja', 'JP'),
      ],
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'Pixiv Func',
      navigatorObservers: [routeObserver],
      home: WillPopScope(
        onWillPop: () async {
          if (null == _lastPopTime || DateTime.now().difference(_lastPopTime!) > const Duration(seconds: 1)) {
            _lastPopTime = DateTime.now();
            Get.find<PlatformApi>().toast(I18n.doubleClickExitHint.tr);
            return false;
          } else {
            return true;
          }
        },
        child: const HomeWidget(),
      ),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      enableLog: false,
    );
  }
}
