import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/platform/webview/platform_webview.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class LoginWebViewPage extends StatelessWidget {
  final bool useLocalReverseProxy;
  final bool create;

  const LoginWebViewPage({Key? key, required this.useLocalReverseProxy, required this.create}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginWebViewController(create));
    return GetBuilder<LoginWebViewController>(
      assignId: true,
      builder: (controller) => ScaffoldWidget(
        actions: [
          if (controller.isLoginPage)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.getLoginDataFromWebView();
                Get.bottomSheet(
                  Container(
                    color: Colors.white,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: Get.height * 0.35, minHeight: Get.height * 0.35),
                      child: Column(
                        children: [
                          const Spacer(flex: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: const [
                                TextWidget('剪切板', fontSize: 18, color: Color(0xFF383838), isBold: true),
                              ],
                            ),
                          ),
                          const Spacer(flex: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                const TextWidget('账号', fontSize: 16, color: Color(0xFF383838), isBold: true),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: controller.accountInputController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(maxHeight: 40),
                                      hintText: '邮箱地址或pixiv ID',
                                      hintStyle: const TextStyle(color: Color(0xFFBCBCBD)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFE9E9EA),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Spacer(flex: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                const TextWidget('密码', fontSize: 16, color: Color(0xFF383838), isBold: true),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: controller.passwordInputController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(maxHeight: 40),
                                      hintText: '密码',
                                      hintStyle: const TextStyle(color: Color(0xFFBCBCBD)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFE9E9EA),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Spacer(flex: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    elevation: 0,
                                    color: const Color(0xFFE9E9EA),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      side: BorderSide.none,
                                    ),
                                    minWidth: double.infinity,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: TextWidget('取消', fontSize: 18, color: Colors.white, isBold: true),
                                    ),
                                    onPressed: () => Get.back(),
                                  ),
                                ),
                                const SizedBox(width: 15),
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
                                      child: TextWidget('复制', fontSize: 18, color: Colors.white, isBold: true),
                                    ),
                                    onPressed: () {
                                      controller.copyLoginDataToWebView();
                                      Get.back();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextWidget('无法输入?', color: Color(0xFFFF6289), fontSize: 14),
                ),
              ),
            ),
          IconButton(onPressed: () => controller.webViewController.reload(), icon: const Icon(Icons.refresh)),
        ],
        title: controller.title,
        child: PlatformWebView(
          tag: 'PlatformWebView:LoginWebViewPage',
          onMessageHandler: controller.onMessageHandler,
          useLocalReverseProxy: useLocalReverseProxy,
          onCreated: controller.onWebViewCreated,
        ),
      ),
    );
  }
}
