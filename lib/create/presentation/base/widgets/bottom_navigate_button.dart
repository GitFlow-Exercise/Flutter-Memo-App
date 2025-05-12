import 'package:flutter/material.dart';

// AI 레이아웃에 사용되는
// 하단 뒤로가기, 다음, 취소 버튼을 구성하는 위젯
class BottomNavigateButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Border? border;
  final Color bgColor;
  final Widget child;
  const BottomNavigateButton({
    super.key,
    this.onTap,
    required this.border,
    required this.child,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: border,
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: child,
      ),
    );
  }
}
