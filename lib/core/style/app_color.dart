import 'package:flutter/material.dart';

// 앱 전역에서 사용되는 색상 정의
abstract class AppColor {
  // Brand Colors
  static const Color primary = Color(0xFF6C63FF); // 메인 강조색, 버튼, 'Mongo AI' 로고
  static const Color secondary = Color(0xFFFFD166); // 즐겨찾기 등

  // Text Colors
  static const Color deepBlack = Color(0xFF2C2C2C); // 주요 제목, 헤더
  static const Color mediumGray = Color(0xFF4A4A4A); // 일반 텍스트
  static const Color lightGray = Color(0xFF717171); // 태그 텍스트
  static const Color paleGray = Color(0xFF9DA3B3); // 아이콘, 부가 텍스트
  static const Color lighterGray = Color(0xFFBDC1CC); // 비활성화된 아이콘
  static const Color hintTextGrey = Color(0xFFADAEBC); // 비활성화된 아이콘
  static const Color tipGrey = Color(0xFF7A8194); // 팁 문구 텍스트

  // Background Colors
  static const Color lightBlue = Color(0xFFF6F7FB); // 패널, 태그 배경
  static const Color paleBlue = Color(0xFFF0F1F7); // 선택된 항목 배경
  static const Color textfieldGrey = Color(0xFFFAFAFA); // 선택된 항목 배경

  // Border / Other Colors
  static const Color lightGrayBorder = Color(0xFFE6E8F0); // 카드 테두리, 구분선
  static const Color paleGrayBorder = Color(0xFFE5E7EB); // 일반 테두리
  static const Color mediumGrayBorder = Color(0xFFCED4DA); // 외부 테두리
  static const Color destructive = Color(0xFFFF6B6B); // Destructive actions
  static const Color circle = Color(0xFF4ECDC4); // circle

  // Black & White
  static const Color white = Color(0xFFFFFFFF); // white
  static const Color black = Color(0xFF000000); // black
}
