import 'package:flutter/material.dart';

// 1,2단계에서 사용되는 기본 로딩 화면
class AiLoadingView extends StatelessWidget {
  const AiLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      width: double.infinity,
      height: double.infinity,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
