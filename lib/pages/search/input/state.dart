import 'package:flutter/cupertino.dart';
import 'package:pixiv_dart_api/vo/search_autocomplete_result.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';

class SearchInputState {
  final TextEditingController wordInput = TextEditingController();

  bool get inputIsNumber => null != int.tryParse(wordInput.text);

  int get inputAsNumber => int.parse(wordInput.text);

  String get inputAsString => wordInput.text;

  SearchFilter filter = SearchFilter.create();
  SearchAutocompleteResult? searchAutocomplete;
  int type = 0;

  DateTime lastInputTime = DateTime.now();
}
