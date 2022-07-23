class ReleaseInfo {
  final String htmlUrl;
  final String tagName;
  final String body;
  final List<ReleaseAsset> assets;

  ReleaseInfo({
    required this.htmlUrl,
    required this.tagName,
    required this.body,
    required this.assets,
  });
}

class ReleaseAsset {
  final String updatedAt;
  final String browserDownloadUrl;

  ReleaseAsset({required this.updatedAt, required this.browserDownloadUrl});
}
