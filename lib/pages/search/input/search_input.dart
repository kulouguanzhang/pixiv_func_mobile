import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/sliding_segmented_control/sliding_segmented_control.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';
import 'package:pixiv_func_mobile/pages/search/filter_editor/filter_editor.dart';
import 'package:pixiv_func_mobile/pages/search/input/controller.dart';

class SearchInputPage extends StatelessWidget {
  const SearchInputPage({Key? key}) : super(key: key);

  Widget _buildInputBox() {
    final controller = Get.find<SearchInputController>();
    final state = Get.find<SearchInputController>().state;
    return TextField(
      controller: state.wordInput,
      onSubmitted: (String value) => controller.toSearchResultPage(value),
      onChanged: controller.wordInputOnChanged,
      decoration: InputDecoration(
        fillColor: Get.theme.backgroundColor,
        filled: true,
        hintText: I18n.searchInputHint.tr,
        border: InputBorder.none,
        prefix: const SizedBox(width: 5),
        suffixIcon: state.inputAsString.isNotEmpty
            ? InkWell(
                onTap: () {
                  state.wordInput.clear();
                  state.searchAutocomplete = null;
                },
                child: const Icon(
                  Icons.clear_outlined,
                  color: Colors.white54,
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SearchInputController());
    final state = Get.find<SearchInputController>().state;

    return GetBuilder<SearchInputController>(
      assignId: true,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: _buildInputBox(),
            actions: [
              IconButton(
                onPressed: () {
                  Get.dialog<SearchFilter>(
                    SearchFilterEditor(
                      filter: state.filter,
                    ),
                  ).then(controller.onFilterChanged);
                },
                icon: const Icon(Icons.filter_alt_outlined),
              ),
            ],
          ),
          body: Column(
            children: [
              SlidingSegmentedControl(
                children: <int, Widget>{
                  0: Text(I18n.illustAndManga.tr),
                  1: Text(I18n.novel.tr),
                  2: Text(I18n.user.tr),
                },
                groupValue: state.type,
                onValueChanged: controller.typeValueOnChanged,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (state.inputIsNumber)
                        if (state.type == 0)
                          ListTile(
                            onTap: () => controller.toIllustPageById(),
                            title: Text('${state.inputAsNumber}'),
                            subtitle: Text('${I18n.illust.tr}ID'),
                          )
                        else if (state.type == 1)
                          ListTile(
                            onTap: () => controller.toNovelPageById(),
                            title: Text('${state.inputAsNumber}'),
                            subtitle: Text('${I18n.novel.tr}ID'),
                          )
                        else if (state.type == 2)
                          ListTile(
                            onTap: () => controller.toUserPageById(),
                            title: Text('${state.inputAsNumber}'),
                            subtitle: Text('${I18n.user.tr}ID'),
                          ),
                      if (null != state.searchAutocomplete)
                        for (var tag in state.searchAutocomplete!.tags)
                          ListTile(
                            onTap: () => controller.toSearchResultPage(tag.name),
                            title: Text(tag.name),
                            subtitle: null != tag.translatedName ? Text(tag.translatedName!) : null,
                          )
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'ToImagePickerHero',
            backgroundColor: Get.theme.colorScheme.onBackground,
            onPressed: () => controller.searchImage(),
            child: const Icon(Icons.image_search_outlined),
          ),
        );
      },
    );
  }
}
