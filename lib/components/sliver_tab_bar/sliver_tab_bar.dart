/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:sliver_tab_bar.dart
 * 创建时间:2021/11/18 下午9:44
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliverTabBar extends StatelessWidget {
  final TabBar child;
  final bool pinned;
  final bool floating;

  const SliverTabBar({
    Key? key,
    required this.child,
    this.pinned = false,
    this.floating = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _SliverTabBarDelegate(child: child),
      pinned: pinned,
      floating: floating,
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  _SliverTabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Get.theme.colorScheme.onSecondary,
      child: child,
    );
  }

  @override
  double get maxExtent => 35;

  @override
  double get minExtent => 35;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => oldDelegate != this;
}
