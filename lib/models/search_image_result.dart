class SearchImageResult {
  ///相似度
  String similarityText;
  int illustId;

  SearchImageResult({required this.similarityText, required this.illustId});

  @override
  String toString() {
    return 'SearchImageResult{similarityText: $similarityText, illustId: $illustId}';
  }
}
