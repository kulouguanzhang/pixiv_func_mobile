/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:loading_more_indicator.dart
 * 创建时间:2021/11/18 下午5:35
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/i18n/i18n.dart';

class LoadingMoreIndicator extends StatelessWidget {
  final IndicatorStatus status;
  final Future<bool> Function() errorRefresh;
  final bool isSliver;
  final bool fullScreenErrorCanRetry;

  const LoadingMoreIndicator({
    Key? key,
    required this.status,
    required this.errorRefresh,
    this.isSliver = false,
    this.fullScreenErrorCanRetry = false,
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
        widget = Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(I18n.statusBusying.tr, style: textStyle),
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
          child: Center(child: Text(I18n.statusError.tr, style: textStyle)),
        );
        break;
      case IndicatorStatus.fullScreenError:
        widget = SizedBox.expand(
          child: fullScreenErrorCanRetry
              ? InkWell(
                  onTap: () => errorRefresh(),
                  child: Center(
                    child: Text(
                      '${I18n.statusError.tr}${fullScreenErrorCanRetry ? ', ${I18n.clickRetry.tr}' : ''}',
                      style: textStyle,
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    I18n.statusError.tr,
                    style: textStyle,
                  ),
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
        widget = Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(I18n.statusNoMoreLoad.tr, style: textStyle),
          ),
        );
        break;
      case IndicatorStatus.empty:
        widget = Center(
          child: Text(I18n.statusEmpty.tr, style: textStyle),
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
