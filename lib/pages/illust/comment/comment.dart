/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:comment.dart
 * 创建时间:2021/11/28 上午12:54
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/entity/comment.dart';
import 'package:pixiv_func_android/app/data/data_tab_view_content.dart';
import 'package:pixiv_func_android/app/local_data/account_manager.dart';
import 'package:pixiv_func_android/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_android/models/comment_tree.dart';
import 'package:pixiv_func_android/pages/illust/comment/controller.dart';
import 'package:pixiv_func_android/pages/user/user.dart';
import 'package:pixiv_func_android/utils/utils.dart';

class IllustCommentPage extends StatelessWidget {
  final int id;

  const IllustCommentPage({Key? key, required this.id}) : super(key: key);

  List<Widget> _buildCommentTileList(List<CommentTree> commentTrees) {
    return [for (final commentTree in commentTrees) _buildCommentTile(commentTree)];
  }

  Widget _buildCommentContent(Comment comment) {
    final commentContent = <Widget>[const SizedBox(height: 5)];
    commentContent.addAll(
      [
        Text(
          comment.user.name,
        ),
        const SizedBox(height: 10),
      ],
    );
    if (null != comment.stamp) {
      commentContent.addAll(
        [
          Image.asset('assets/stamps/stamp-${comment.stamp!.stampId}.jpg'),
          const SizedBox(height: 10),
        ],
      );
    }
    if (comment.comment.isNotEmpty) {
      commentContent.addAll(
        [
          Text(comment.comment),
          const SizedBox(height: 10),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: commentContent,
    );
  }

  Widget _buildCommentTile(CommentTree commentTree) {
    final controller = Get.find<IllustCommentController>(tag: '$runtimeType:$id');
    if (commentTree.children.isEmpty) {
      return Card(
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 5, right: 5),
          leading: GestureDetector(
            onTap: () => Get.to(UserPage(id: commentTree.data.user.id)),
            child: Hero(
              tag: 'UserHero:${commentTree.data.user.id}',
              child: AvatarFromUrl(commentTree.data.user.profileImageUrls.medium),
            ),
          ),
          onLongPress: () => controller.repliesCommentTree = commentTree,
          title: _buildCommentContent(commentTree.data),
          subtitle: Get.find<AccountService>().currentUserId == commentTree.data.user.id
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                      style: const TextStyle(color: Colors.white54),
                    ),
                    Expanded(child: Container()),
                    OutlinedButton(
                      onPressed: () => controller.doDeleteComment(commentTree),
                      child: const Text('删除'),
                    )
                  ],
                )
              : Text(
                  Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                  style: const TextStyle(color: Colors.white54),
                ),
          trailing: commentTree.loading
              ? const CircularProgressIndicator()
              : commentTree.data.hasReplies
                  ? InkWell(
                      onTap: () => controller.loadFirstReplies(commentTree),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, top: 2, bottom: 2),
                        child: Text(
                          '···',
                          style: TextStyle(fontSize: 21, color: Get.theme.colorScheme.primary),
                        ),
                      ),
                    )
                  : null,
        ),
      );
    } else {
      final children = _buildCommentTileList(commentTree.children);

      if (commentTree.loading) {
        children.add(
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      } else if (commentTree.hasNext) {
        children.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Card(
              child: ListTile(
                onTap: () => controller.loadNextReplies(commentTree),
                title: const Center(child: Text('点击加载更多')),
              ),
            ),
          ),
        );
      }

      return Card(
        child: InkWell(
          onLongPress: () => controller.repliesCommentTree = commentTree,
          child: ExpansionTile(
            tilePadding: const EdgeInsets.only(left: 5, right: 5),
            leading: GestureDetector(
              onTap: () => Get.to(UserPage(id: commentTree.data.user.id)),
              child: Hero(
                tag: 'user:${commentTree.data.user.id}',
                child: AvatarFromUrl(commentTree.data.user.profileImageUrls.medium),
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 20),
            children: children,
            title: _buildCommentContent(commentTree.data),
            subtitle: Get.find<AccountService>().currentUserId == commentTree.data.user.id
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                        style: const TextStyle(color: Colors.white54),
                      ),
                      Expanded(child: Container()),
                      OutlinedButton(
                        onPressed: () => controller.doDeleteComment(commentTree),
                        child: const Text('删除'),
                      )
                    ],
                  )
                : Text(
                    Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                    style: const TextStyle(color: Colors.white54),
                  ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType:$id';
    Get.put(IllustCommentController(id), tag: controllerTag);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const SliverAppBar(
              title: Text('插画的评论'),
            )
          ];
        },
        body: GetBuilder<IllustCommentController>(
          tag: controllerTag,
          assignId: true,
          builder: (IllustCommentController controller) {
            return DataTabViewContent(
              sourceList: controller.source,
              itemBuilder: (BuildContext context, CommentTree item, int index) {
                return _buildCommentTile(item);
              },
            );
          },
        ),
        floatHeaderSlivers: true,
      ),
    );
  }
}
