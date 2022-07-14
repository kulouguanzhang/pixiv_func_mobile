class ReleaseInfo {
  String htmlUrl;
  String tagName;

  //更新时间
  DateTime updateAt;
  String browserDownloadUrl;
  String body;

  ReleaseInfo({
    required this.htmlUrl,
    required this.tagName,
    required this.updateAt,
    required this.browserDownloadUrl,
    required this.body,
  });
}
