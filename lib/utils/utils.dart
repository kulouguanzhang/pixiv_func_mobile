import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pixiv_dart_api/model/image_urls.dart';
import 'package:pixiv_func_mobile/app/settings/app_settings.dart';

class Utils {
  /// 枚举类型(的值)转小写下划线字符串
  /// SearchTarget.partialMatchForTags => 'partial_match_for_tags'
  /// 用于API
  static String enumToPixivParameter<T extends Enum>(T type) {
    final typeString = type.toString();

    final typeValueString = typeString.substring(typeString.indexOf('.') + 1);
    return typeValueString.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) {
        return '_${match.input.substring(match.start, match.end)}';
      },
    ).toLowerCase();
  }

  ///日本时间转中国时间
  static String japanDateToLocalDateString(DateTime dateTime) {
    return DateFormat('yyyy年MM月dd日 HH:mm:ss').format(dateTime.toLocal());
  }

  static Future<void> copyToClipboard(String data) async {
    await Clipboard.setData(ClipboardData(text: data));
  }

  static String replaceImageSource(String url) {
    return url.replaceFirst('i.pximg.net', Get.find<AppSettingsService>().imageSource);
  }

  static String getPreviewUrl(ImageUrls imageUrls) {
    return Get.find<AppSettingsService>().previewQuality ? imageUrls.large : imageUrls.medium;
  }

  ///字符串是否是 twitter/用户名
  static bool textIsTwitterUser(String text) {
    return RegExp(r'([Tt]witter/)(\w{1,15})\b').hasMatch(text);
  }

  ///查找文本里的推特用户名
  static String findTwitterUsernameByText(String url) {
    return RegExp(r'(?<=([Tt]witter/))(\w{1,15})\b$').stringMatch(url)!;
  }

  ///推特账号(https://twitter.com https://mobile.twitter.com)
  static bool urlIsTwitter(String url) {
    return RegExp(r'(https://).*(twitter.com/)(\w{1,15})\b$').hasMatch(url);
  }

  ///查找url里的推特用户名
  static String findTwitterUsernameByUrl(String url) {
    return RegExp(r'(?<=(https://).*(twitter.com/))(\w{1,15})\b$').stringMatch(url)!;
  }

  ///插画页面
  static bool urlIsIllust(String url) {
    return RegExp(r'pixiv://illusts/([1-9][0-9]*)\b').hasMatch(url);
  }

  ///查找url里的插画ID
  static int findIllustIdByUrl(String url) {
    return int.parse(RegExp(r'(?<=pixiv://illusts/)([1-9][0-9]*)\b').stringMatch(url)!);
  }

  ///用户页面
  static bool urlIsUser(String url) {
    return RegExp(r'pixiv://users/([1-9][0-9]*)\b').hasMatch(url);
  }

  ///查找url里的用户ID
  static int findUserIdByUrl(String url) {
    return int.parse(RegExp(r'(?<=pixiv://users/)([1-9][0-9]*)\b').stringMatch(url)!);
  }
}
