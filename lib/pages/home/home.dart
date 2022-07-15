import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/pages/home/controller.dart';
import 'package:pixiv_func_mobile/pages/ranking/ranking.dart';
import 'package:pixiv_func_mobile/pages/recommended/recommended.dart';
import 'package:pixiv_func_mobile/pages/search_guide/search_guide.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder: (controller) => Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: controller.index,
              children: const [
                RecommendedPage(),
                RankingPage(),
                SearchGuidePage(),
                SizedBox(),
              ],
            ),
          ),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.index,
            onTap: (int index) => controller.index = index,
            items: const [
              BottomNavigationBarItem(
                label: '推荐',
                icon: Icon(Icons.alt_route_outlined),
              ),
              BottomNavigationBarItem(
                label: '排行',
                icon: Icon(Icons.leaderboard_outlined),
              ),
              BottomNavigationBarItem(
                label: '搜索',
                icon: Icon(Icons.search_outlined),
              ),
              BottomNavigationBarItem(
                label: '我的',
                icon: Icon(Icons.account_circle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
