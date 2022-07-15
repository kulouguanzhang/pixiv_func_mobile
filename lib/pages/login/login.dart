import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/pages/login/controller.dart';
import 'package:pixiv_func_mobile/pages/login/web_view/login_web_view.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return GetBuilder<LoginController>(
      builder: (controller) => ScaffoldWidget(
        emptyAppBar: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
          child: Column(
            children: [
              const Spacer(flex: 1),
              const TextWidget('注册 或 登录', fontSize: 24, isBold: true),
              const Spacer(flex: 2),
              SizedBox(
                height: Get.height * 0.4,
                child: Column(
                  children: [
                    CupertinoSwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 6),
                      onTap: () => controller.useLocalReverseProxy = !controller.useLocalReverseProxy,
                      value: controller.useLocalReverseProxy,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const TextWidget('本地反向代理', fontSize: 18, isBold: true),
                          const SizedBox(width: 8),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              controller.help = !controller.help;
                            },
                            child: const Icon(Icons.info_outline, color: Color(0xFFFF6289)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    if (controller.help)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Pixiv官方页面无法注册或登陆时，建议开启本地反向代理，稍后您可以在设置中进行相应变更。',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            TextSpan(
                              text: '获取更多帮助 >>',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    if (controller.help)
                      Column(
                        children: const [
                          TextWidget('或使用', fontSize: 18, isBold: true),
                          TextWidget('长按头像复制账号数据', fontSize: 18, isBold: true),
                          SizedBox(height: 10),
                        ],
                      ),
                    if (controller.help)
                      MaterialButton(
                        elevation: 0,
                        color: const Color(0xFFFF6289),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        minWidth: double.infinity,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextWidget('从剪贴板登陆', fontSize: 18, color: Colors.white, isBold: true),
                        ),
                        onPressed: () => controller.loginFromClipboard(),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: const BorderSide(color: Color(0xFFFF6289)),
                              ),
                              minWidth: double.infinity,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: TextWidget('注册', fontSize: 18, color: Color(0xFFFF6289), isBold: true),
                              ),
                              onPressed: () => Get.to(
                                LoginWebViewPage(
                                  useLocalReverseProxy: controller.useLocalReverseProxy,
                                  create: true,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: MaterialButton(
                              elevation: 0,
                              color: const Color(0xFFFF6289),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              minWidth: double.infinity,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: TextWidget('登录', fontSize: 18, color: Colors.white, isBold: true),
                              ),
                              onPressed: () => Get.to(
                                LoginWebViewPage(
                                  useLocalReverseProxy: controller.useLocalReverseProxy,
                                  create: false,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              const TextWidget('登录即表示您同意', fontSize: 14),
              const TextWidget('《Pixiv Func用户使用协议》', fontSize: 14, color: Color(0xFFFF6289)),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
