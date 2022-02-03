/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:controller.dart
 * 创建时间:2021/11/29 下午6:18
 * 作者:小草
 */

import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html show parse;
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/models/search_image_item.dart';
import 'package:pixiv_func_android/models/search_image_result.dart';
import 'package:pixiv_func_android/utils/log.dart';

class SearchImageResultController extends GetxController {
  final Uint8List imageBytes;
  final String filename;

  SearchImageResultController({required this.imageBytes, required this.filename});

  final list = <SearchImageItem>[];

  final httpClient = Dio(BaseOptions(
    sendTimeout: 60000,
  ));

  final CancelToken cancelToken = CancelToken();

  bool loading = false;
  bool initFailed = false;

  void loadData(SearchImageItem item) {
    item.loading = true;
    update();
    Get.find<ApiClient>().getIllustDetail(item.result.illustId, cancelToken: cancelToken).then((result) {
      item.loading = false;
      item.illust = result.illust;
      update();
    }).catchError((e, s) {
      item.loading = false;
      if (e is DioError && HttpStatus.notFound == e.response?.statusCode) {
        remove(item.result.illustId);
      } else {
        item.loadFailed = true;
      }
      update();
    });
  }

  void remove(int id) {
    list.removeWhere((item) => id == item.result.illustId);
  }

  Future<void> init() async {
    list.clear();
    loading = true;
    initFailed = false;
    update();
    final fromData = FormData()
      ..files.add(
        MapEntry(
          'file',
          MultipartFile.fromBytes(imageBytes, filename: filename),
        ),
      );
    // ..fields.add(
    //   const MapEntry(
    //     'dbs[]',
    //     //pixiv Images
    //     '5',
    //   ),
    // );

    httpClient.post<String>('https://saucenao.com/search.php', data: fromData, cancelToken: cancelToken).then((response) {
      final document = html.parse(response.data!);
      decodeSearchHtml(document).forEach((result) {
        list.add(SearchImageItem(result));
      });

      for (final item in list) {
        loadData(item);
      }
    }).catchError((e, s) {
      if (e is DioError && DioErrorType.cancel == e.type) {
        return;
      }
      Log.e('搜索图片失败', e);
      initFailed = true;
    }).whenComplete(() {
      loading = false;
      update();
    });
  }

  List<SearchImageResult> decodeSearchHtml(html.Document document) {
    final list = <SearchImageResult>[];
    //td标签
    final contents = document.querySelectorAll('.resulttablecontent');
    for (final td in contents) {
      //一个div
      final similarityDiv = td.querySelector('.resultsimilarityinfo');

      //a标签
      final links = td.querySelectorAll('.linkify');

      final illustLinkIndex = links.indexWhere((a) {
        final href = a.attributes['href'];
        return (href != null && href.startsWith('https://www.pixiv.net/') && href.contains('illust_id'));
      });

      if (-1 != illustLinkIndex) {
        final illustHref = links[illustLinkIndex].attributes['href'];
        if (null != illustHref && null != similarityDiv) {
          final illustId = int.tryParse(Uri.parse(illustHref).queryParameters['illust_id'] ?? '');
          final similarityText = similarityDiv.text;
          if (null != illustId && similarityText.isNotEmpty) {
            list.add(
              SearchImageResult(
                similarityText: similarityText,
                illustId: illustId,
              ),
            );
          }
        }
      }
    }

    return list;
  }
}
