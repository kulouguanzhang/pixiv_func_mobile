import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  void _login({bool create = false}) {
    final controller = Get.find<LoginController>();
    Get.dialog<bool>(
      AlertDialog(
        title: const Text('登录'),
        content: const Text('是否启用本地反向代理(IP直连)?'),
        actions: [
          OutlinedButton(onPressed: () => Get.back(result: true), child: const Text('启用')),
          OutlinedButton(onPressed: () => Get.back(result: false), child: const Text('不启用')),
        ],
      ),
    ).then((bool? value) {
      if (null != value) {
        controller.login(create, value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    final state = Get.find<LoginController>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixiv Func'),
      ),
      body: GetBuilder<LoginController>(
        assignId: true,
        builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const ListTile(
                title: Text('如果无法正常直连是需要开代理(VPN)的'),
                subtitle: Text('开代理请点不启用按钮'),
              ),
              const Divider(),
              Card(
                child: ListTile(
                  onTap: state.agreementAccepted ? () => _login() : null,
                  title: const Center(child: Text('登录')),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: state.agreementAccepted ? () => _login(create: true) : null,
                  title: const Center(child: Text('注册')),
                ),
              ),
              Card(
                child: CheckboxListTile(
                  activeColor: Get.theme.colorScheme.primary,
                  value: state.agreementAccepted,
                  onChanged: controller.agreementOnChanged,
                  title: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(text: '我同意并接受'),
                        TextSpan(
                          text: '夹批搪与牲口不得使用此软件',
                          style: TextStyle(color: Get.theme.colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
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
