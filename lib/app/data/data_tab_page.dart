/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:data_tab_page.dart
 * 创建时间:2021/11/27 下午3:23
 * 作者:小草
 */

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/app/data/data_tab_config.dart';
import 'package:pixiv_func_android/app/data/data_tab_view_content.dart';
import 'package:pixiv_func_android/components/auto_keep/auto_keep.dart';
import 'package:pixiv_func_android/components/pull_to_refresh_header/pull_to_refresh_header.dart';
import 'package:pixiv_func_android/components/sliver_tab_bar/sliver_tab_bar.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class DataTabPage extends StatefulWidget {
  final String title;
  final List<DataTabConfig> tabs;
  final List<Widget>? actions;
  final bool isScrollable;
  final bool floatHeaderSlivers;
  final NestedScrollViewPinnedHeaderSliverHeightBuilder? pinnedHeaderSliverHeightBuilder;
  final Widget? flexibleSpace;
  final double? expandedHeight;

  const DataTabPage({
    Key? key,
    required this.title,
    required this.tabs,
    this.actions,
    this.isScrollable = false,
    this.floatHeaderSlivers = true,
    this.pinnedHeaderSliverHeightBuilder,
    this.flexibleSpace,
    this.expandedHeight,
  }) : super(key: key);

  @override
  _DataTabPageState createState() => _DataTabPageState();
}

class _DataTabPageState extends State<DataTabPage> with TickerProviderStateMixin {
  late final tabController = TabController(length: widget.tabs.length, vsync: this);

  @override
  void initState() {
    for (final tab in widget.tabs) {
      if (tab.isCustomChild) {
        assert(null == tab.source, 'isCustomChild为true时 source必须为null');
        assert(null == tab.gridDelegate, 'isCustomChild为true时 gridDelegate必须为null');
        assert(null == tab.extendedListDelegate, 'isCustomChild为true时 extendedListDelegate必须为null');
      } else {
        assert(null != tab.source, 'isCustomChild为false时 source不可为null');
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    for (final tab in widget.tabs) {
      tab.source?.dispose();
    }
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PullToRefreshNotification(
      maxDragOffset: 100,
      child: ExtendedNestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              // forceElevated: innerBoxIsScrolled,
              title: Text(widget.title),
              actions: widget.actions,
              flexibleSpace: widget.flexibleSpace,
              expandedHeight: widget.expandedHeight,
            ),
            PullToRefreshContainer((info) => PullToRefreshHeader(info: info)),
            SliverTabBar(
              child: TabBar(
                controller: tabController,
                isScrollable: widget.isScrollable,
                onTap: (int index) => tabBarOnTap(context, index),
                tabs: [
                  for (final tab in widget.tabs) Tab(child: Text(tab.name)),
                ],
              ),
              pinned: true,
            ),
          ];
        },
        pinnedHeaderSliverHeightBuilder: widget.pinnedHeaderSliverHeightBuilder,
        body: TabBarView(
          controller: tabController,
          children: [
            for (final tab in widget.tabs)
              if (tab.isCustomChild)
                tab.itemBuilder(context, null, 0)
              else
                AutomaticKeepWidget(
                  child: DataTabViewContent(
                    sourceList: tab.source!,
                    itemBuilder: tab.itemBuilder,
                    gridDelegate: tab.gridDelegate,
                    extendedListDelegate: tab.extendedListDelegate,
                  ),
                ),
          ],
        ),
        floatHeaderSlivers: widget.floatHeaderSlivers,
        onlyOneScrollInBody: true,
      ),
      onRefresh: onRefresh,
    );
  }

  Future<bool> onRefresh() async {
    PrimaryScrollController.of(context)!.jumpTo(widget.expandedHeight ?? 0);
    final tab = widget.tabs[tabController.index];
    if (tab.isCustomChild) {
      return true;
    } else {
      return await tab.source!.refresh(true);
    }
  }

  void tabBarOnTap(BuildContext context, int index) {
    final tab = widget.tabs[index];

    if (index == tabController.index) {
      if (!tab.isCustomChild) {
        if (false == tab.source?.isLoading) {
          tab.source?.refresh(true);
        }
      }
    }
  }
}
