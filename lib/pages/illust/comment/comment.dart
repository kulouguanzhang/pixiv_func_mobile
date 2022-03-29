/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:comment.dart
 * 创建时间:2021/11/28 上午12:54
 * 作者:小草
 */
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/entity/comment.dart';
import 'package:pixiv_func_mobile/app/data/data_content.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/local_data/account_manager.dart';
import 'package:pixiv_func_mobile/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_mobile/components/pull_to_refresh_header/pull_to_refresh_header.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';
import 'package:pixiv_func_mobile/pages/illust/comment/controller.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

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
                      child: Text(I18n.delete.tr),
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
                title: Center(child: Text(I18n.loadingMore.tr)),
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
                tag: 'UserHero:${commentTree.data.user.id}',
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
                        child: Text(I18n.delete.tr),
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
    final controller = Get.put(IllustCommentController(id), tag: controllerTag);
    return Scaffold(
      body: PullToRefreshNotification(
        onRefresh: () async => await controller.source.refresh(true),
        maxDragOffset: 100,
        child: ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(title: Text(I18n.comment.tr)),
              PullToRefreshContainer((info) => PullToRefreshHeader(info: info)),
            ];
          },
          body: GetBuilder<IllustCommentController>(
            tag: controllerTag,
            assignId: true,
            builder: (IllustCommentController controller) {
              return Column(
                children: [
                  Flexible(
                    child: DataContent(
                      sourceList: controller.source,
                      itemBuilder: (BuildContext context, CommentTree item, int index) {
                        return _buildCommentTile(item);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => controller.repliesCommentTree = null,
                        icon: const Icon(
                          Icons.reply_sharp,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: controller.commentInput,
                          decoration: InputDecoration(
                            labelText: controller.commentInputLabel,
                            prefix: const SizedBox(width: 5),
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.commentInput.clear();
                              },
                              child: const Icon(
                                Icons.close_sharp,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ElevatedButton(
                          onPressed: controller.doAddComment,
                          child: Text(I18n.send.tr),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
