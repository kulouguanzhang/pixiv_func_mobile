import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/components/lazy_indexed_stack/lazy_indexed_stack.dart';
import 'package:pixiv_func_android/pages/ranking/ranking.dart';
import 'package:pixiv_func_android/pages/recommended/recommended.dart';
import 'package:pixiv_func_android/pages/search/search.dart';
import 'package:pixiv_func_android/pages/self/self.dart';

class AppBodyPage extends StatelessWidget {
  const AppBodyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObxValue<RxInt>(
      (data) {
        return Scaffold(
          body: LazyIndexedStack(
            index: data.value,
            children: const [
              RecommendedPage(),
              RankingPage(),
              SearchPage(),
              SelfPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: data.value,
            onTap: (int index) => data.value = index,
            items: const [
              BottomNavigationBarItem(
                label: '推荐',
                icon: Icon(Icons.alt_route_outlined),
              ),
              BottomNavigationBarItem(
                label: '排行榜',
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
        );
      },
      0.obs,
    );
  }
}
