import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/components/loading_more_indicator/loading_more_indicator.dart';
import 'data_source_base.dart';

class DataContent<T> extends StatefulWidget {
  final DataSourceBase<T> Function() sourceList;
  final bool isCustomScrollView;
  final EdgeInsetsGeometry padding;
  final SliverGridDelegate? gridDelegate;
  final ExtendedListDelegate? extendedListDelegate;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const DataContent({
    Key? key,
    required this.sourceList,
    this.isCustomScrollView = false,
    required this.itemBuilder,
    this.gridDelegate,
    this.extendedListDelegate,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
  }) : super(key: key);

  @override
  State<DataContent<T>> createState() => _DataContentState();
}

class _DataContentState<T> extends State<DataContent<T>> {
  late final LoadingMoreBase<T> sourceList;

  @override
  void initState() {
    sourceList = widget.sourceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isCustomScrollView){
      return LoadingMoreSliverList(
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
      );
    }else{
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
