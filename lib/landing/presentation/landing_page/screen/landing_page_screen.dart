import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mongo_ai/core/debounce/debounce.dart';
import 'package:mongo_ai/landing/presentation/landing_page/screen/landing_page_view/landing_create_problem_view.dart';
import 'package:mongo_ai/landing/presentation/landing_page/screen/landing_page_view/landing_introduce_view.dart';
import 'package:mongo_ai/landing/presentation/landing_page/screen/landing_page_view/landing_key_features_view.dart';
import 'package:mongo_ai/landing/presentation/landing_page/screen/landing_page_view/landing_start_view.dart';

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  _LandingPageScreenState createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  final _pageController = PageController();
  // PageView 물리(physics)를 동적으로 바꿀 Notifier
  final _physicsNotifier = ValueNotifier<ScrollPhysics>(
    const PageScrollPhysics(),
  );
  final Debouncer debouncer = Debouncer(
    delay: const Duration(microseconds: 500),
  );

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        print(notification);
        // notification.depth == 0 이면 PageView의 스크롤 상태,
        // notification.depth > 0 이면 하위 위젯이 스크롤 상태
        if (notification.depth > 0 &&
            notification is ScrollUpdateNotification &&
            notification.scrollDelta != null &&
            notification.scrollDelta! < 0.0) {
          print('page scroll stop1');
          _physicsNotifier.value = const NeverScrollableScrollPhysics();
        }
        if (notification.depth > 0) {
          // 하위 위젯이 스크롤 중이라면 pageview의 스크롤을 막고
          _physicsNotifier.value = const NeverScrollableScrollPhysics();
          print('page scroll stop2');

          // 하위 위젯의 스크롤이 끝났다면 다시 재작동하도록 설정
          if (notification is UserScrollNotification &&
              notification.metrics is FixedScrollMetrics &&
              notification.direction == ScrollDirection.idle) {
            print('page scroll restart');
            debouncer.run(() {
              _physicsNotifier.value = const PageScrollPhysics();
            });
          }
        }

        return false; // false로 놔야 PageView 쪽 알림도 받습니다.
      },
      child: ValueListenableBuilder<ScrollPhysics>(
        valueListenable: _physicsNotifier,
        builder: (_, physics, __) {
          return PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: physics,
            children: const [
              LandingIntroduceView(),
              LandingKeyFeaturesView(),
              LandingCreateProblemView(),
              LandingStartView(),
            ],
          );
        },
      ),
    );
  }
}
