/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:api_client.dart
 * 创建时间:2021/8/21 下午12:47
 * 作者:小草
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'dto/bookmark_tags.dart';
import 'dto/comments.dart';
import 'dto/error_message.dart';
import 'dto/illust_detail.dart';
import 'dto/illusts.dart';
import 'dto/novels.dart';
import 'dto/search_autocomplete.dart';
import 'dto/search_illust.dart';
import 'dto/search_novel.dart';
import 'dto/trending_tags.dart';
import 'dto/ugoira_metadata.dart';
import 'dto/user_detail.dart';
import 'dto/users.dart';
import 'entity/comment.dart';
import 'interceptors/auth_token_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

class ApiClient extends GetxService {
  static const _targetIP = '210.140.92.183';
  static const _targetHost = 'app-api.pixiv.net';

  Dio get _httpClient {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://$_targetIP',
        responseType: ResponseType.plain,
        headers: {
          'User-Agent': 'PixivAndroidApp/6.21.1 (Android 7.1.2; XiaoCao)',
          'App-OS': 'android',
          'App-OS-Version': '7.1.2',
          'App-Version': '6.21.1',
          'Accept-Language': Get.locale!.toLanguageTag(),
          'Host': _targetHost
        },
        connectTimeout: 5 * 1000,
        receiveTimeout: 5 * 1000,
        sendTimeout: 5 * 1000,
      ),
    );
    dio.interceptors.addAll(
      [
        RetryInterceptor(dio, hasMore: true),
        AuthTokenInterceptor(dio),
      ],
    );
    return dio;
  }

  Future<T> next<T>(
    String url, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      url.replaceFirst(_targetHost, _targetIP),
      cancelToken: cancelToken,
    );

    final responseData = response.data!;

    if (T == Comments) {
      return Comments.fromJson(jsonDecode(responseData)) as T;
    }
    if (T == Illusts) {
      return Illusts.fromJson(jsonDecode(responseData)) as T;
    }
    if (T == Novels) {
      return Novels.fromJson(jsonDecode(responseData)) as T;
    }
    if (T == Users) {
      return Users.fromJson(jsonDecode(responseData)) as T;
    }
    if (T == SearchIllust) {
      return SearchIllust.fromJson(jsonDecode(responseData)) as T;
    }
    if (T == BookmarkTags) {
      return BookmarkTags.fromJson(jsonDecode(responseData)) as T;
    }
    throw Exception('类型错误');
  }

  ///获取用户详细信息 <br/>
  ///如果没有查询到会返回404 : [ErrorMessage.fromJson] => <br/>
  ///[userId] - 用户ID
  Future<UserDetail> getUserDetail(
    int userId, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/user/detail',
      queryParameters: {
        'filter': 'for_android',
        'user_id': userId,
      },
      cancelToken: cancelToken,
    );
    final data = UserDetail.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取用户收藏的插画 <br/>
  ///[userId] - 用户ID <br/>
  ///[restrict] - 为ture获取公开的(public) 反之不公开(private)
  Future<Illusts> getUserIllustBookmarks(
    int userId, {
    bool restrict = true,
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/user/bookmarks/illust',
      queryParameters: {
        'user_id': userId,
        'restrict': restrict ? 'public' : 'private',
      },
      cancelToken: cancelToken,
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取用户收藏的小说 <br/>
  ///[userId] - 用户ID <br/>
  ///[restrict] - 为ture获取公开的(public) 反之不公开(private)
  Future<Novels> getUserNovelBookmarks(
    int userId, {
    bool restrict = true,
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/user/bookmarks/novel',
      queryParameters: {
        'user_id': userId,
        'restrict': restrict ? 'public' : 'private',
      },
      cancelToken: cancelToken,
    );
    final data = Novels.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取用户的插画 <br/>
  ///[userId] - 用户ID <br/>
  ///[type] - 类型([WorkType])
  Future<Illusts> getUserIllusts(
    int userId,
    String type, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/user/illusts',
      queryParameters: {
        'filter': 'for_android',
        'user_id': userId,
        'type': type,
      },
      cancelToken: cancelToken,
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取用户的小说 <br/>
  ///[userId] - 用户ID <br/>
  Future<Novels> getUserNovels(
    int userId, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/user/novels',
      queryParameters: {
        'user_id': userId,
      },
      cancelToken: cancelToken,
    );
    final data = Novels.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取推荐插画 <br/>
  ///[type] - 类型([WorkType])
  Future<Illusts> getRecommendedIllusts(
    String type, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/$type/recommended',
      queryParameters: {
        'filter': 'for_android',
      },
      cancelToken: cancelToken,
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取推荐小说
  Future<Novels> getRecommendedNovels({
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/novel/recommended',
      queryParameters: {
        'include_ranking_novels': false,
        'include_privacy_policy': false,
      },
      cancelToken: cancelToken,
    );
    final data = Novels.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取排行榜 <br/>
  ///[mode] - 方式([RankingMode])
  Future<Illusts> getRanking(
    String mode, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/illust/ranking',
      queryParameters: {
        'filter': 'for_android',
        'mode': mode,
      },
      cancelToken: cancelToken,
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取推荐标签(搜索用的)
  Future<TrendingTags> getTrendingTags({
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/trending-tags/illust',
      queryParameters: {
        'filter': 'for_android',
      },
      cancelToken: cancelToken,
    );
    final data = TrendingTags.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取推荐用户
  Future<Users> getRecommendedUsers({
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/user/recommended',
      queryParameters: {
        'filter': 'for_android',
      },
      cancelToken: cancelToken,
    );
    final data = Users.fromJson(jsonDecode(response.data!));
    return data;
  }

  Future<Users> getFollower(
    int userId, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/user/follower',
      queryParameters: {
        'filter': 'for_android',
        'user_id': userId,
      },
      cancelToken: cancelToken,
    );
    final data = Users.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取关注用户 <br/>
  ///[userId] - 用户ID <br/>
  ///[restrict] - 为ture获取公开的(public) 反之不公开(private)
  Future<Users> getFollowingUsers(
    int userId, {
    bool restrict = true,
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/user/following',
      queryParameters: {
        'filter': 'for_android',
        'user_id': userId,
        'restrict': restrict ? 'public' : 'private',
      },
      cancelToken: cancelToken,
    );
    final data = Users.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取关注者的新插画 <br/>
  ///[restrict] - 为ture获取公开的(public) 反之不公开(private) null(全部)
  Future<Illusts> getFollowerNewIllusts({
    required bool? restrict,
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v2/illust/follow',
      queryParameters: {
        'filter': 'for_android',
        'restrict': null == restrict
            ? 'all'
            : restrict
                ? 'public'
                : 'private',
      },
      cancelToken: cancelToken,
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取关注者的新小说 <br/>
  ///[restrict] - 为ture获取公开的(public) 反之不公开(private) null(全部)
  Future<Novels> getFollowerNewNovels({
    required bool? restrict,
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/novel/follow',
      queryParameters: {
        'filter': 'for_android',
        'restrict': null == restrict
            ? 'all'
            : restrict
                ? 'public'
                : 'private',
      },
      cancelToken: cancelToken,
    );
    final data = Novels.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取最近发布的插画 <br/>
  ///[type] - 类型([WorkType]) illust , manga
  Future<Illusts> getNewIllusts(
    String type, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/illust/new',
      queryParameters: {
        'filter': 'for_android',
        'content_type': type,
      },
      cancelToken: cancelToken,
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取最近发布的小说
  Future<Novels> getNewNovels({
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/novel/new',
      cancelToken: cancelToken,
    );
    final data = Novels.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取插画的相关推荐 <br/>
  ///[illustId] - 插画ID
  Future<Illusts> getIllustRelated(
    int illustId, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v2/illust/related',
      queryParameters: {
        'filter': 'for_android',
        'illust_id': illustId,
      },
      cancelToken: cancelToken,
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取插画详细 <br/>
  ///如果没有查询到会返回404 : [ErrorMessage.fromJson] => <br/>
  ///{ user_message:"该作品已被删除，或作品ID不存在。", message:"", reason:"", user_message_details:{} } <br/>
  ///[illustId] - 插画ID <br/>
  Future<IllustDetail> getIllustDetail(
    int illustId, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/illust/detail',
      queryParameters: {
        'filter': 'for_android',
        'illust_id': illustId,
      },
      cancelToken: cancelToken,
    );

    final data = IllustDetail.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取小说HTML页面 <br/>
  ///[novelId] - 小说ID
  Future<String> getNovelHtml(
    int novelId, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/webview/v1/novel',
      queryParameters: {
        'id': novelId,
      },
      cancelToken: cancelToken,
    );
    return response.data!;
  }

  ///获取动图
  ///[illustId] 插画ID
  Future<UgoiraMetadata> getUgoiraMetadata(
    int illustId, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/ugoira/metadata',
      queryParameters: {
        'illust_id': illustId,
      },
      cancelToken: cancelToken,
    );

    final data = UgoiraMetadata.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取评论的回复 <br/>
  ///[commentId] - 评论ID
  Future<Comments> getCommentReplies(
    int commentId, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v2/illust/comment/replies',
      queryParameters: {
        'comment_id': commentId,
      },
      cancelToken: cancelToken,
    );
    final data = Comments.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取插画的评论 <br/>
  ///[illustId] - 插画ID
  Future<Comments> getIllustComments(
    int illustId, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v3/illust/comments',
      queryParameters: {
        'illust_id': illustId,
      },
      cancelToken: cancelToken,
    );
    final data = Comments.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///**搜索**的**关键字**自动补全 <br/>
  ///[word] - 关键字
  Future<SearchAutocomplete> searchAutocomplete(
    String word, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v2/search/autocomplete',
      queryParameters: {
        'merge_plain_keyword_results': true,
        'word': word,
      },
      cancelToken: cancelToken,
    );
    final data = SearchAutocomplete.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///搜索 <br/>
  ///[word] - 关键字 <br/>
  ///[sort] - 排序([SearchSort]) <br/>
  ///[target] - 搜索目标([SearchTarget]) <br/>
  ///[startDate] - 开始时间(必须跟[endDate]一起填) <br/>
  ///[endDate] - 结束时间(必须跟[startDate]一起填) <br/>
  ///[bookmarkTotal] - 收藏数量 100, 250, 500, 1000, 5000, 7500 , 10000, 20000, 30000, 50000
  Future<SearchIllust> searchIllust(
    String word,
    String sort,
    String target, {
    String? startDate,
    String? endDate,
    int? bookmarkTotal,
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/search/illust',
      queryParameters: {
        'filter': 'for_android',
        'include_translated_tag_results': true,
        'merge_plain_keyword_results': true,
        'word': null != bookmarkTotal ? '$word ${bookmarkTotal}users入り' : word,
        'sort': sort,
        'search_target': target,
        'start_date': startDate,
        'end_date': endDate,
      }..removeWhere((key, value) => null == value),
      cancelToken: cancelToken,
    );
    final data = SearchIllust.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///搜索 <br/>
  ///[word] - 关键字 <br/>
  ///[sort] - 排序([SearchSort]) <br/>
  ///[target] - 搜索目标([SearchTarget]) <br/>
  ///[startDate] - 开始时间(必须跟[endDate]一起填) <br/>
  ///[endDate] - 结束时间(必须跟[startDate]一起填) <br/>
  ///[bookmarkTotal] - 收藏数量 100, 250, 500, 1000, 5000, 7500, 10000, 20000, 30000, 50000
  Future<SearchNovel> searchNovel(
    String word,
    String sort,
    String target, {
    String? startDate,
    String? endDate,
    int? bookmarkTotal,
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/search/novel',
      queryParameters: {
        'include_translated_tag_results': true,
        'merge_plain_keyword_results': true,
        'word': null != bookmarkTotal ? '$word ${bookmarkTotal}users入り' : word,
        'sort': sort,
        'search_target': target,
        'start_date': startDate,
        'end_date': endDate,
      }..removeWhere((key, value) => null == value),
      cancelToken: cancelToken,
    );
    final data = SearchNovel.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///搜索用户
  Future<Users> searchUsers(
    String word, {
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/search/user',
      queryParameters: {
        'filter': 'for_android',
        'word': word,
      },
      cancelToken: cancelToken,
    );
    final data = Users.fromJson(jsonDecode(response.data!));
    return data;
  }

  Future<BookmarkTags> getBookmarkTags(
    int userId, {
    bool restrict = true,
    bool isNovel = false,
    required CancelToken cancelToken,
  }) async {
    final response = await _httpClient.get<String>(
      '/v1/user/bookmark-tags/${isNovel ? 'novel' : 'illust'}',
      queryParameters: {
        'user_id': userId,
        'restrict': restrict ? 'public' : 'private',
      },
      cancelToken: cancelToken,
    );
    final data = BookmarkTags.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///收藏作品 <br/>
  ///[id] - 作品ID <br/>
  ///[tags] - 标签(自己添加的) <br/>
  ///[restrict] 为ture获取公开的(public) 反之不公开(private) <br/>
  ///[isNovel] 小说
  Future<void> addBookmark(int id, {List<String> tags = const [], bool restrict = true, bool isNovel = false}) async {
    await _httpClient.post<String>(
      '/v2/${isNovel ? 'novel' : 'illust'}/bookmark/add',
      data: FormData.fromMap(
        {
          '${isNovel ? 'novel' : 'illust'}_id': id,
          'restrict': restrict ? 'public' : 'private',
          'tags': tags,
        },
      ),
    );
  }

  ///取消收藏作品 <br/>
  ///[id] - 作品ID <br/>
  ///[isNovel] 小说
  Future<void> deleteBookmark(
    int id, {
    bool isNovel = false,
  }) async {
    await _httpClient.post<String>(
      '/v1/${isNovel ? 'novel' : 'illust'}/bookmark/delete',
      data: FormData.fromMap(
        {
          '${isNovel ? 'novel' : 'illust'}_id': id,
        },
      ),
    );
  }

  ///关注用户 <br/>
  ///[userId] - 用户ID <br/>
  ///[restrict] 为ture获取公开的(public) 反之不公开(private)
  Future<void> addFollow(
    int userId, {
    bool restrict = true,
  }) async {
    await _httpClient.post<String>(
      '/v1/user/follow/add',
      data: FormData.fromMap(
        {
          'user_id': userId,
          'restrict': restrict ? 'public' : 'private',
        },
      ),
    );
  }

  ///取消关注用户 <br/>
  ///[userId] - 用户ID
  Future<void> deleteFollow(int userId) async {
    await _httpClient.post<String>(
      '/v1/user/follow/delete',
      data: FormData.fromMap(
        {
          'user_id': userId,
        },
      ),
    );
  }

  ///添加评论(评论一个插画) <br/>
  ///[illustId] - 插画ID <br/>
  ///[comment] - 评论内容 <br/>
  ///[stampId] - 表情包ID <br/>
  ///[parentCommentId] - 父评论ID(用来回复)
  Future<Comment> addComment(
    int illustId, {
    String comment = '',
    int? stampId,
    int? parentCommentId,
  }) async {
    final response = await _httpClient.post<String>(
      '/v1/illust/comment/add',
      data: FormData.fromMap(
        {
          'illust_id': illustId,
          'comment': comment,
          'stamp_id': stampId,
          'parent_comment_id': parentCommentId,
        }..removeWhere((key, value) => null == value),
      ),
    );
    final data = Comment.fromJson(jsonDecode(response.data!)['comment']);
    return data;
  }

  ///删除评论(自己的) <br/>
  ///[commentId] - 评论ID
  Future<void> deleteComment(int commentId) async {
    await _httpClient.post<String>(
      '/v1/illust/comment/delete',
      data: FormData.fromMap(
        {
          'comment_id': commentId,
        },
      ),
    );
  }
}
