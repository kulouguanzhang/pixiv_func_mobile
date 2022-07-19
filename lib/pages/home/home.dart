import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/pages/new/new.dart';
import 'package:pixiv_func_mobile/pages/ranking/ranking.dart';
import 'package:pixiv_func_mobile/pages/recommended/recommended.dart';
import 'package:pixiv_func_mobile/pages/search_guide/search_guide.dart';
import 'package:pixiv_func_mobile/pages/user/me.dart';

import 'controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
        body: IndexedStack(
          index: controller.index,
          children: const [
            RecommendedPage(),
            RankingPage(),
            NewPage(),
            SearchGuidePage(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).colorScheme.background,
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.index = 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Icon(
                      AppIcons.home,
                      color: controller.index == 0 ? Theme.of(context).colorScheme.primary : null,
                      size: 35,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.index = 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Icon(
                      AppIcons.ranking,
                      color: controller.index == 1 ? Theme.of(context).colorScheme.primary : null,
                      size: 35,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.index = 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Icon(
                      AppIcons.n,
                      color: controller.index == 2 ? Theme.of(context).colorScheme.primary : null,
                      size: 35,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.index = 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Icon(
                      AppIcons.search,
                      color: controller.index == 3 ? Theme.of(context).colorScheme.primary : null,
                      size: 35,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(const MePage()),
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      AppIcons.me,
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
