import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/comment.dart';
import 'package:pixiv_func_mobile/app/data/account_service.dart';
import 'package:pixiv_func_mobile/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';
import 'package:pixiv_func_mobile/pages/illust/comment/controller.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class IllustCommentContent extends StatelessWidget {
  final int id;

  const IllustCommentContent({Key? key, required this.id}) : super(key: key);

  Widget _buildCommentContent(Comment comment) {
    return Padding(
      //头像框的大小+边距
      padding: const EdgeInsets.only(left: 32 + 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (null != comment.stamp)
            Image.asset('assets/stamps/stamp-${comment.stamp!.stampId}.jpg')
          else if (comment.comment.isNotEmpty)
            TextWidget(comment.comment, fontSize: 14),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentTree commentTree) {
    final controller = Get.find<IllustCommentController>(tag: '$runtimeType:$id');
    if (commentTree.children.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  // onTap: () => Get.to(UserPage(id: commentTree.data.user.id)),
                  child: Hero(
                    tag: 'UserHero:${commentTree.data.user.id}',
                    child: AvatarFromUrl(commentTree.data.user.profileImageUrls.medium, radius: 32),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(commentTree.data.user.name, fontSize: 12, isBold: true),
                    TextWidget(commentTree.data.date, fontSize: 10),
                  ],
                ),
                const Spacer(),
                if (Get.find<AccountService>().currentUserId == commentTree.data.user.id)
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.delete),
                    onPressed: () => controller.onCommentDelete(commentTree),
                  ),
                if (commentTree.loading) const CupertinoActivityIndicator(),
              ],
            ),
          ),
          subtitle: _buildCommentContent(commentTree.data),
          trailing: commentTree.data.hasReplies
              ? IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.more_vert_outlined, color: Get.theme.colorScheme.primary),
                  onPressed: () => controller.loadFirstReplies(commentTree),
                )
              : null,
        ),
      );
    } else {
      final children = [
        for (final commentTree in commentTree.children) _buildCommentItem(commentTree),
        if (commentTree.loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (commentTree.hasNext)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: InkWell(
              onTap: () => controller.loadNextReplies(commentTree),
              child: Row(
                children: const [
                  Icon(Icons.more_outlined),
                  SizedBox(width: 5),
                  Text('加载更多...'),
                ],
              ),
            ),
          ),
      ];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ExpansionTile(
          title: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    // onTap: () => Get.to(UserPage(id: commentTree.data.user.id)),
                    child: Hero(
                      tag: 'UserHero:${commentTree.data.user.id}',
                      child: AvatarFromUrl(commentTree.data.user.profileImageUrls.medium, radius: 32),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    children: [
                      TextWidget(commentTree.data.user.name, fontSize: 12, isBold: true),
                      TextWidget(commentTree.data.date, fontSize: 10),
                    ],
                  ),
                  const Spacer(),
                  if (Get.find<AccountService>().currentUserId == commentTree.data.user.id)
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.delete),
                      onPressed: () => controller.onCommentDelete(commentTree),
                    ),
                  if (commentTree.loading) const CupertinoActivityIndicator(),
                  if (commentTree.data.hasReplies)
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.more_vert_outlined, color: Get.theme.colorScheme.primary),
                      onPressed: () => controller.onCommentDelete(commentTree),
                    ),
                ],
              ),
              _buildCommentContent(commentTree.data),
            ],
          ),
          children: children,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType:$id';

    Get.put(IllustCommentController(id), tag: controllerTag);
    return GetBuilder<IllustCommentController>(
      tag: controllerTag,
      assignId: true,
      builder: (IllustCommentController controller) {
        return Column(
          children: [
            Flexible(
              child: DataContent(
                sourceList: () => controller.source,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, CommentTree item, int index) {
                  return _buildCommentItem(item);
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
                    onPressed: controller.onCommentAdd,
                    child: const TextWidget('发送'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
