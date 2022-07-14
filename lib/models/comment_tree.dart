import 'package:pixiv_dart_api/model/comment.dart';

class CommentTree {
  Comment data;
  CommentTree? parent;
  List<CommentTree> children = [];
  bool loading = false;
  String? nextUrl;

  CommentTree({required this.data, required this.parent});

  bool get hasNext => null != nextUrl;
}
