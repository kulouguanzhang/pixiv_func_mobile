import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/components/loading_more_indicator/loading_more_indicator.dart';
import 'package:pixiv_func_mobile/components/pull_to_refresh_header/pull_to_refresh_header.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

import 'data_source_base.dart';

class DataContent<T> extends StatefulWidget {
  final DataSourceBase<T> sourceList;
  final EdgeInsetsGeometry padding;
  final SliverGridDelegate? gridDelegate;
  final ExtendedListDelegate? extendedListDelegate;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final bool pullToRefresh;

  const DataContent({
    Key? key,
    required this.sourceList,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.gridDelegate,
    this.extendedListDelegate,
    required this.itemBuilder,
    this.pullToRefresh = true,
  }) : super(key: key);

  @override
  State<DataContent<T>> createState() => _DataContentState();
}

class _DataContentState<T> extends State<DataContent<T>> {
  late DataSourceBase<T> sourceList = widget.sourceList;

  @override
  void didUpdateWidget(covariant DataContent<T> oldWidget) {
    if (widget.sourceList != oldWidget.sourceList) {
      sourceList = widget.sourceList;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pullToRefresh) {
      return PullToRefreshNotification(
        onRefresh: () async => await sourceList.refresh(true),
        maxDragOffset: 100,
        child: NoScrollBehaviorWidget(
          child: LoadingMoreCustomScrollView(
            slivers: [
              PullToRefreshContainer((info) => PullToRefreshHeader(info: info)),
              LoadingMoreSliverList(
                SliverListConfig(
                  padding: widget.padding,
                  extendedListDelegate: widget.extendedListDelegate,
                  gridDelegate: widget.gridDelegate,
                  sourceList: sourceList,
                  itemBuilder: widget.itemBuilder,
                  indicatorBuilder: (BuildContext context, IndicatorStatus status) => LoadingMoreIndicator(
                    status: status,
                    errorRefresh: () async => await sourceList.errorRefresh(),
                    isSliver: true,
                    fullScreenErrorCanRetry: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return LoadingMoreList(
        ListConfig(
          padding: widget.padding,
          showGlowLeading: false,
          showGlowTrailing: false,
          primary: true,
          itemBuilder: widget.itemBuilder,
          sourceList: sourceList,
          extendedListDelegate: widget.extendedListDelegate,
          gridDelegate: widget.gridDelegate,
          itemCountBuilder: (int count) => sourceList.length,
          indicatorBuilder: (BuildContext context, IndicatorStatus status) => LoadingMoreIndicator(
            status: status,
            errorRefresh: () async => await sourceList.errorRefresh(),
          ),
        ),
      );
    }
  }
}
