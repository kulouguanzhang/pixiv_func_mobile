/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novel.dart
 * 创建时间:2021/11/25 下午4:34
 * 作者:小草
 */

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/components/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_android/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_android/pages/novel/controller.dart';

class NovelPage extends StatelessWidget {
  final int id;
  final int page;

  const NovelPage({
    Key? key,
    required this.id,
    this.page = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType:$id';
    final controller = Get.put(NovelController(id), tag: controllerTag);
    return GetBuilder<NovelController>(
      tag: controllerTag,
      assignId: true,
      initState: (state) {
        controller.loadData();
      },
      builder: (NovelController controller) {
        final Widget widget;
        if (controller.loading) {
          widget = const SizedBox.expand(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (controller.error) {
          widget = GestureDetector(
            onTap: () => controller.loadData(),
            child: const SizedBox.expand(
              child: Center(
                child: Text('加载失败 点击重新加载', style: TextStyle(fontSize: 25)),
              ),
            ),
          );
        } else if (controller.notFound) {
          widget = SizedBox.expand(
            child: Center(
              child: Text('小说:$id不存在', style: const TextStyle(fontSize: 25)),
            ),
          );
        } else {
          if (null != controller.novelJSData) {
            final novelJSData = controller.novelJSData!;
            widget = CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ImageFromUrl(novelJSData.coverUrl),
                ),
                SliverToBoxAdapter(
                  child: HtmlRichText(novelJSData.text),
                ),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: null != novelJSData.seriesNavigation?.prevNovel,
                    child: ListTile(
                      onTap: () => Get.back(),
                      title: const Text('上一页'),
                      subtitle: Text('${novelJSData.seriesNavigation?.prevNovel?.title}'),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: null != novelJSData.seriesNavigation?.nextNovel,
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          NovelPage(
                            id: novelJSData.seriesNavigation!.nextNovel!.id,
                            page: 1 + page,
                          ),
                          preventDuplicates: false,
                        );
                      },
                      title: const Text('下一页'),
                      subtitle: Text('${novelJSData.seriesNavigation?.nextNovel?.title}'),
                    ),
                  ),
                ),
              ],
            );
          } else {
            widget = const SizedBox();
          }
        }
        return ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text('小说 第${page + 1}页'),
                actions: [
                  IconButton(
                    onPressed: () => controller.loadData(),
                    icon: const Icon(Icons.refresh_outlined),
                  )
                ],
              )
            ];
          },
          body: Scaffold(body: widget),
          floatHeaderSlivers: true,
        );
      },
    );
  }
}
