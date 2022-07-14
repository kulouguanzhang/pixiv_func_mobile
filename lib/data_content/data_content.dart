import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/components/loading_more_indicator/loading_more_indicator.dart';
import 'package:pixiv_func_mobile/widgets/auto_keep/auto_keep.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'data_source_base.dart';

class DataContent<T> extends StatefulWidget {
  final DataSourceBase<T> Function() sourceList;
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
    return AutomaticKeepWidget(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: NoScrollBehaviorWidget(
          child: LoadingMoreList(
            ListConfig(
              showGlowLeading: false,
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
          ),
        ),
      ),
    );
  }
}
