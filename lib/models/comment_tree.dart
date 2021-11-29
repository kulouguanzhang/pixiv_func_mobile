/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:comment_tree.dart
 * 创建时间:2021/11/28 上午12:59
 * 作者:小草
 */

import 'package:pixiv_func_android/app/api/entity/comment.dart';

class CommentTree {
  Comment data;
  CommentTree? parent;
  List<CommentTree> children = [];
  bool loading = false;
  String? nextUrl;

  CommentTree({required this.data, required this.parent});

  bool get hasNext => null != nextUrl;
}
