import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/i18n/i18n.dart';

import 'controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixiv Func'),
      ),
      body: GetBuilder<LoginController>(
        assignId: true,
        builder: (controller) {
          final state = Get.find<LoginController>().state;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CheckboxListTile(
                value: state.useReverseProxy,
                onChanged: controller.useReverseProxyOnChanged,
                title: Text(I18n.useReverseProxy.tr),
              ),
              const Divider(),
              Card(
                child: ListTile(
                  onTap: () => controller.login(false),
                  title: Center(child: Text(I18n.login.tr)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => controller.login(true),
                  title: Center(child: Text(I18n.register.tr)),
                ),
              ),
              const SizedBox(height: 150),
            ],
          );
        },
      ),
    );
  }
}
