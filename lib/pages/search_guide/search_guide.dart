import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/vo/trending_tag_list_result.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/pages/illust/illust.dart';
import 'package:pixiv_func_mobile/pages/search/result/illust/search_illust_result.dart';
import 'package:pixiv_func_mobile/pages/search/result/image/search_image_result.dart';
import 'package:pixiv_func_mobile/pages/search/search.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'source.dart';

class SearchGuidePage extends StatelessWidget {
  const SearchGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      titleWidget: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.to(() => const SearchPage()),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    hintText: '搜索关键字或ID',
                    prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onBackground),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 3),
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                  ),
                ),
              ),
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
                child: Row(
                  children: const [
                    Icon(Icons.image, color: Colors.white, size: 14),
                    TextWidget('搜图', fontSize: 14, color: Colors.white, isBold: true),
                  ],
                ),
                onPressed: ()  {
                  ImagePicker().pickImage(source: ImageSource.gallery).then((picker) async {
                    if (null != picker) {
                      picker.readAsBytes();
                      Get.to(()async =>
                        SearchImageResultPage(
                          imageBytes: await picker.readAsBytes(),
                          filename: picker.name,
                        ),
                      );
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
      child: DataContent(
        sourceList: SearchTrendingIllustList(),
        extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 7.5),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemBuilder: (BuildContext context, TrendTag item, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.to(() => SearchIllustResultPage(keyword: item.tag)),
                onLongPress: () => Get.to(() => IllustPage(illust: item.illust)),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ImageFromUrl(item.illust.imageUrls.squareMedium),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget('#${item.tag}', fontSize: 14, isBold: true, overflow: TextOverflow.ellipsis),
                      TextWidget(item.translatedName ?? '', fontSize: 10, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
