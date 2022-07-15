import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/pages/search/controller.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Get.put(SearchController(this));
    return GetBuilder<SearchController>(
      builder: (controller) => VisibilityDetector(
        key: Key(runtimeType.toString()),
        child: ScaffoldWidget(
          automaticallyImplyLeading: false,
          titleWidget: SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: controller.focusNode,
                    controller: controller.searchContentInput,
                    onChanged: (value) => controller.searchContentOnChanged(value),
                    onSubmitted: (value) => controller.toSearchResultPage(value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        gapPadding: 0,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      hintText: '搜索',
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 3),
                      fillColor: Theme.of(context).colorScheme.surface,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.back(),
                  child: TextWidget('取消', color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  height: 40,
                  child: MaterialButton(
                    elevation: 0,
                    color: const Color(0xFFFF6289),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // minWidth: double.infinity,
                    child: Center(
                      child: Row(
                        children: const [
                          Icon(Icons.image, color: Colors.white, size: 14),
                          TextWidget('搜图', fontSize: 14, color: Colors.white, isBold: true),
                        ],
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              TabBarWidget(
                controller: controller.tabController,
                indicatorMinWidth: 15,
                indicator: const RRecTabIndicator(
                  radius: 4,
                  insets: EdgeInsets.only(bottom: 5),
                ),
                tabs: const [
                  Tab(text: '插画&漫画'),
                  Tab(text: '小说'),
                  Tab(text: '用户'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    NoScrollBehaviorWidget(
                      child: ListView(
                        children: [
                          for (final tag in controller.autocompleteTags)
                            ListTile(
                              onTap: () => controller.toSearchResultPage(tag.name),
                              title: TextWidget(tag.name, fontSize: 16, isBold: true),
                              subtitle: null != tag.translatedName ? TextWidget(tag.translatedName!, fontSize: 12) : null,
                            )
                        ],
                      ),
                    ),
                    const SizedBox(),
                    const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
        onVisibilityChanged: (VisibilityInfo visibilityInfo) {
          if(visibilityInfo.visibleFraction != 0.0){
            controller.focusNode.requestFocus();
          }
        },
      ),
    );
  }
}
