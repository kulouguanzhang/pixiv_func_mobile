import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/comment.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/services/account_service.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

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
    final controller = Get.find<IllustCommentController>(tag: '$runtimeType-$id');
    final Widget widget;
    if (commentTree.children.isEmpty) {
      widget = ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => UserPage(id: commentTree.data.user.id)),
              child: PixivAvatarWidget(commentTree.data.user.profileImageUrls.medium, radius: 32),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(commentTree.data.user.name, fontSize: 12, isBold: true),
                TextWidget(Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)), fontSize: 10),
              ],
            ),
            const Spacer(),
            if (Get.find<AccountService>().currentUserId == commentTree.data.user.id)
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete),
                onPressed: () => controller.onCommentDelete(commentTree),
              ),
          ],
        ),
        subtitle: _buildCommentContent(commentTree.data),
        trailing: () {
          if (commentTree.data.hasReplies) {
            if (commentTree.loading) {
              return CupertinoActivityIndicator(color: Get.theme.colorScheme.onSurface);
            } else {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Icon(Icons.more_vert_outlined, color: Get.theme.colorScheme.primary, size: 24),
                onTap: () => controller.loadFirstReplies(commentTree),
              );
            }
          }
        }(),
      );
    } else {
      final children = [
        for (final commentTree in commentTree.children) _buildCommentItem(commentTree),
        if (commentTree.loading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CupertinoActivityIndicator(color: Get.theme.colorScheme.onSurface)),
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

      widget = ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20),
        childrenPadding: const EdgeInsets.only(left: 20),
        initiallyExpanded: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => UserPage(id: commentTree.data.user.id)),
              child: PixivAvatarWidget(commentTree.data.user.profileImageUrls.medium, radius: 32),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(commentTree.data.user.name, fontSize: 12, isBold: true),
                TextWidget(Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)), fontSize: 10),
              ],
            ),
            const Spacer(),
          ],
        ),
        subtitle: _buildCommentContent(commentTree.data),
        children: children,
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType-$id';

    Get.put(IllustCommentController(id), tag: controllerTag);
    return GetBuilder<IllustCommentController>(
      tag: controllerTag,
      builder: (IllustCommentController controller) {
        return Column(
          children: [
            Flexible(
              child: DataContent(
                sourceList: controller.source,
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
