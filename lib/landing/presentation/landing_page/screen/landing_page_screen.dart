import 'package:flutter/material.dart';

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('랜딩페이지\n홈, 요금제만 동작합니다\n무료로 시작하기 클릭 시 로그인으로 이동합니다.'),
    );
  }
}
