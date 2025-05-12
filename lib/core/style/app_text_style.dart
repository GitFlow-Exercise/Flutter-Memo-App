import 'package:flutter/material.dart';

// 앱 전역에서 사용하는 텍스트 스타일 정의
abstract class AppTextStyle {
  // Pretendard Variable Font
  static const String fontFamily = 'PretendardVariable';

  // Logo, Header 등 - Bold(700), 20px
  static const TextStyle titleBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  // 카드 제목 등 - Medium(500), 18px
  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  // 일반, 버튼, 네비게이션 항목 - Medium(500), 16px
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // 폴더 네비게이션 항목 등 - Regular(400), 16px
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // 부가정보 - Medium(500), 14px
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // 태그 텍스트 - Regular(400), 14px
  static const TextStyle captionRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
