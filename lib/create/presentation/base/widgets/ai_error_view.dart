import 'package:flutter/material.dart';

// TODO 명우: 좀 더 상세히 에러 화면 수정하기
// 1,2단계에서 사용되는 기본 에러 화면
class AiErrorView extends StatelessWidget {
  const AiErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('에러가 발생하였습니다.'));
  }
}
