/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:loading_more_indicator.dart
 * 创建时间:2021/11/18 下午5:35
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class LoadingMoreIndicator extends StatelessWidget {
  final IndicatorStatus status;
  final Future<bool> Function() errorRefresh;
  final bool isSliver;

  const LoadingMoreIndicator({
    Key? key,
    required this.status,
    required this.errorRefresh,
    this.isSliver = false,
  }) : super(key: key);

  static const textStyle = TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (status) {
      case IndicatorStatus.none:
        widget = const SizedBox();
        break;
      case IndicatorStatus.loadingMoreBusying:
        widget = const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text("正在加载...", style: textStyle),
          ),
        );
        break;
      case IndicatorStatus.fullScreenBusying:
        widget = const Center(
          child: CircularProgressIndicator(),
        );
        if (isSliver) {
          widget = SliverFillRemaining(child: widget);
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.error:
        widget = InkWell(
          onTap: () => errorRefresh(),
          child: const Center(child: Text('加载失败 点击重试', style: textStyle)),
        );
        break;
      case IndicatorStatus.fullScreenError:
        widget = const SizedBox.expand(
          child: Center(
            child: Text('加载失败', style: textStyle),
          ),
        );

        if (isSliver) {
          widget = SliverFillRemaining(child: widget);
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.noMoreLoad:
        widget = const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text('没有更多数据了', style: textStyle),
          ),
        );
        break;
      case IndicatorStatus.empty:
        widget = const Center(
          child: Text('没有任何数据', style: textStyle),
        );
        if (isSliver) {
          widget = SliverFillRemaining(child: widget);
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
    }
    return widget;
  }
}
