import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/components/loading_more_indicator/loading_more_indicator.dart';
import 'data_source_base.dart';

class DataContent<T> extends StatelessWidget {
  final DataSourceBase<T> sourceList;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final SliverGridDelegate? gridDelegate;
  final ExtendedListDelegate? extendedListDelegate;

  const DataContent({
    Key? key,
    required this.sourceList,
    required this.itemBuilder,
    this.gridDelegate,
    this.extendedListDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingMoreList(
      ListConfig(
        showGlowLeading: false,
        primary: true,
        itemBuilder: itemBuilder,
        sourceList: sourceList,
        extendedListDelegate: extendedListDelegate,
        gridDelegate: gridDelegate,
        itemCountBuilder: (int count) => sourceList.length,
        indicatorBuilder: (BuildContext context, IndicatorStatus status) => LoadingMoreIndicator(
          status: status,
          errorRefresh: () async => await sourceList.errorRefresh(),
        ),
      ),
    );
  }
}
