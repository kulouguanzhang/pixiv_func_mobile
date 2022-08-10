import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/components/select_button/select_button.dart';
import 'package:pixiv_func_mobile/components/single_picker/single_picker.dart';
import 'package:pixiv_func_mobile/pages/user/me_settings/profile/controller.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class MeProfileSettingsPage extends StatelessWidget {
  final UserDetailResult currentDetail;

  const MeProfileSettingsPage({Key? key, required this.currentDetail}) : super(key: key);

  Map<String, Publicity> get publicityItems => {
        '公开': Publicity.public,
        '仅自己': Publicity.private,
        '好P友': Publicity.mypixiv,
      };

  @override
  Widget build(BuildContext context) {
    Get.put(MeProfileSettingsController(currentDetail));
    return GetBuilder<MeProfileSettingsController>(
      builder: (controller) => ScaffoldWidget(
        title: '个人资料设置',
        child: () {
          if (PageState.loading == controller.state) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          } else if (PageState.error == controller.state) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => controller.loadData(),
              child: Container(
                alignment: Alignment.center,
                child: const TextWidget('加载失败,点击重试', fontSize: 16),
              ),
            );
          } else {
            return Column(
              children: [
                Flexible(
                  child: NoScrollBehaviorWidget(
                    child: ListView(
                      children: [
                        CupertinoContextMenu(
                          actions: <Widget>[
                            CupertinoContextMenuAction(
                              child: TextWidget('修改', color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                Get.back();
                                controller.selectProfileImage();
                              },
                            ),
                            CupertinoContextMenuAction(
                              child: const TextWidget('删除'),
                              onPressed: () {
                                Get.back();
                                controller.deleteProfileImage();
                              },
                            ),
                          ],
                          child: Container(
                            //不这样点击空白区域不响应事件
                            color: Theme.of(context).colorScheme.background,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                              child: Row(
                                children: [
                                  if (null == controller.newProfileImage)
                                    PixivAvatarWidget(
                                      controller.profileImageUrl ?? controller.presetsResult!.profilePresets.defaultProfileImageUrls.medium,
                                      radius: 60,
                                    )
                                  else
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: ExtendedImage.memory(
                                        controller.newProfileImage!,
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                  const SizedBox(width: 45),
                                  TextWidget(
                                    '头像',
                                    fontSize: 22,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          previewBuilder: (
                            BuildContext context,
                            Animation<double> animation,
                            Widget child,
                          ) {
                            if (null == controller.newProfileImage) {
                              return PixivAvatarWidget(
                                controller.profileImageUrl ?? controller.presetsResult!.profilePresets.defaultProfileImageUrls.medium,
                                radius: 180,
                              );
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(180),
                                child: ExtendedImage.memory(
                                  controller.newProfileImage!,
                                  fit: BoxFit.cover,
                                  width: 180,
                                  height: 180,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 90,
                                child: TextWidget('昵称', fontSize: 22),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: controller.userNameController,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: InputDecoration(
                                    constraints: const BoxConstraints(maxHeight: 40),
                                    hintText: '昵称',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 90,
                                child: TextWidget('主页', fontSize: 22),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: controller.webpageController,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: InputDecoration(
                                    constraints: const BoxConstraints(maxHeight: 40),
                                    hintText: '主页',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 90,
                                child: TextWidget('Twitter', fontSize: 22),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: controller.twitterController,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: InputDecoration(
                                    constraints: const BoxConstraints(maxHeight: 40),
                                    hintText: 'Twitter ID',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              SinglePicker(
                                title: '性别',
                                items: const {
                                  '男性': Gender.male,
                                  '女性': Gender.female,
                                  '未选择': Gender.unknown,
                                },
                                initialValue: controller.gender,
                                onChanged: controller.genderOnChanged,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 90,
                                  child: TextWidget('性别', fontSize: 22),
                                ),
                                const SizedBox(width: 20),
                                TextWidget(controller.genderName, fontSize: 20),
                                const Spacer(),
                                SelectButtonWidget(
                                  items: publicityItems,
                                  value: controller.genderPublicity,
                                  onChanged: controller.genderPublicityOnChanged,
                                  width: 35,
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              SinglePicker<int>(
                                title: '地址',
                                items: {}..addEntries(controller.presetsResult!.profilePresets.addresses.map((item) => MapEntry(item.name, item.id))),
                                initialValue: controller.addressId,
                                onChanged: controller.addressIdOnChanged,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 90,
                                  child: TextWidget('地址', fontSize: 22),
                                ),
                                const SizedBox(width: 20),
                                TextWidget(controller.addressName, fontSize: 20),
                                const Spacer(),
                                SelectButtonWidget(
                                  items: publicityItems,
                                  value: controller.addressPublicity,
                                  onChanged: controller.addressPublicityOnChanged,
                                  width: 35,
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (controller.addressIsGlobal)
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                SinglePicker<String>(
                                  title: '国家',
                                  items: {}
                                    ..addEntries(controller.presetsResult!.profilePresets.countries.map((item) => MapEntry(item.name, item.code))),
                                  initialValue: controller.countryCode,
                                  onChanged: controller.countryCodeOnChanged,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: TextWidget('国家', fontSize: 22),
                                  ),
                                  const SizedBox(width: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: TextWidget(controller.countryName, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    helpText: '生日')
                                .then((value) {
                              if (null != value) {
                                controller.birthdayOnChanged(value);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 90,
                                      child: TextWidget('生日', fontSize: 22),
                                    ),
                                    const SizedBox(width: 20),
                                    TextWidget(controller.birthYear, fontSize: 20),
                                    const Spacer(),
                                    SelectButtonWidget(
                                      items: publicityItems,
                                      value: controller.birthYearPublicity,
                                      onChanged: controller.birthYearPublicityOnChanged,
                                      width: 35,
                                      height: 70,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(width: 110),
                                    TextWidget(controller.birthMonthDay, fontSize: 20),
                                    const Spacer(),
                                    SelectButtonWidget(
                                      items: publicityItems,
                                      value: controller.birthMonthDayPublicity,
                                      onChanged: controller.birthMonthDayPublicityOnChanged,
                                      width: 35,
                                      height: 70,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              SinglePicker<int>(
                                title: '工作',
                                items: {}..addEntries(controller.presetsResult!.profilePresets.jobs.map((item) => MapEntry(item.name, item.id))),
                                initialValue: controller.jobId,
                                onChanged: controller.jobIdOnChanged,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 90,
                                  child: TextWidget('工作', fontSize: 22),
                                ),
                                const SizedBox(width: 20),
                                TextWidget(controller.jobName, fontSize: 20),
                                const Spacer(),
                                SelectButtonWidget(
                                  items: publicityItems,
                                  value: controller.jobPublicity,
                                  onChanged: controller.jobPublicityOnChanged,
                                  width: 35,
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 90,
                                child: TextWidget('简介', fontSize: 22),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextField(
                                  controller: controller.commentController,
                                  maxLines: 10,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: InputDecoration(
                                    hintText: '写点什么吧',
                                    hintStyle: const TextStyle(fontSize: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, bottom: 35),
                  child: MaterialButton(
                    elevation: 0,
                    color: const Color(0xFFFF6289),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    minWidth: double.infinity,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: TextWidget('更新个人资料', fontSize: 18, color: Colors.white, isBold: true),
                    ),
                    onPressed: () => controller.updateProfile(),
                  ),
                ),
              ],
            );
          }
        }(),
      ),
    );
  }
}
