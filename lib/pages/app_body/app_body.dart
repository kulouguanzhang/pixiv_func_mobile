import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/lazy_indexed_stack/lazy_indexed_stack.dart';
import 'package:pixiv_func_mobile/pages/ranking/ranking.dart';
import 'package:pixiv_func_mobile/pages/recommended/recommended.dart';
import 'package:pixiv_func_mobile/pages/search/search.dart';
import 'package:pixiv_func_mobile/pages/self/self.dart';

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
            items: [
              BottomNavigationBarItem(
                label: I18n.recommended.tr,
                icon: const Icon(Icons.alt_route_outlined),
              ),
              BottomNavigationBarItem(
                label: I18n.ranking.tr,
                icon: const Icon(Icons.leaderboard_outlined),
              ),
              BottomNavigationBarItem(
                label: I18n.search.tr,
                icon: const Icon(Icons.search_outlined),
              ),
              BottomNavigationBarItem(
                label: I18n.self.tr,
                icon: const Icon(Icons.account_circle),
              ),
            ],
          ),
        );
      },
      0.obs,
    );
  }
}
