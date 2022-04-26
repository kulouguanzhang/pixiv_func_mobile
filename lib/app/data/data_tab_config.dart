import 'package:flutter/cupertino.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';

class DataTabConfig<T> {
  final String name;
  final DataSourceBase<T>? source;
  final SliverGridDelegate? gridDelegate;
  final ExtendedListDelegate? extendedListDelegate;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final bool isCustomChild;

  DataTabConfig({
    required this.name,
    required this.source,
    this.gridDelegate,
    this.extendedListDelegate,
    required this.itemBuilder,
    this.isCustomChild = false,
  });
}
