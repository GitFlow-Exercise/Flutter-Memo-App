import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_event.freezed.dart';

@freezed
sealed class AppEventState with _$AppEventState {
  // 1) 스낵바 이벤트 처리
  const factory AppEventState.showSnackBar({required String message}) =
      ShowSnackBar;

  // 2) 네비게이션 이벤트 처리
  // routeName : 이동할 경로
  // extra : extra 데이터
  // navigateMethod : 이동할 방법(go, push ...)
  const factory AppEventState.navigate({
    required String routeName,
    dynamic extra,
    @Default(NavigationMethod.go) NavigationMethod navigateMethod,
  }) = Navigate;

  // 3) 다이아로그 이벤트 처리
  // builder : context를 인자로 받는 빌더 함수
  // barrierDismissible : 외부 터치시 해제 가능한지 설정하는 변수
  const factory AppEventState.showDialog({
    required Widget Function(BuildContext) builder,
    @Default(true) bool barrierDismissible,
  }) = ShowDialog;

  // 4) ---이벤트 추가---
}

// Navigation 이동 방법
enum NavigationMethod { push, go }
