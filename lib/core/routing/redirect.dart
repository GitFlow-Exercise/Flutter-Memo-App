import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/domain/model/create_workbook_params.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

abstract class AppRedirect {
  // 인증 관련 redirect 로직입니다.
  static String? authRedirect({
    required bool isAuthenticated,
    required bool isInitialSetupUser,
    required String? nowPath,
    required Object? extra,
  }) {
    // 디버깅용 로그
    print('Redirect Check: $nowPath, extra type: ${extra?.runtimeType}, isAuth: $isAuthenticated, isInitialSetup: $isInitialSetupUser');

    // [수정점 1] - extra 손실 체크 로직
    // 회원가입 관련 페이지가 아니고, extra가 String 타입이 아닌 경우에는 signIn으로 리다이렉트
    // nowPath가 signUp도 아니고 extra도 없는 경우 로그인 화면으로 강제 이동
    if (nowPath != Routes.signUp && extra is! String && !isAuthenticated) {
      return Routes.signIn;
    }

    // 인증되지 않은 경우
    if (!isAuthenticated) {
      // 회원가입 관련 경로는 인증 없이도 접근 가능
      if (nowPath == Routes.signUp ||
          nowPath == Routes.signUpPassword ||
          nowPath == Routes.checkOtp ||
          nowPath == Routes.signUpComplete) {
        return null; // 정상 진행
      }

      return Routes.signIn;
    }

    // [수정점 2] - 회원가입 완료 화면 특별 처리
    // 회원가입 완료 화면은 예외적으로 항상 접근 허용
    if (nowPath == Routes.signUpComplete) {
      return null; // 회원가입 완료 화면은 그대로 진행
    }

    // [수정점 3] - 초기 설정 완료 여부 체크
    // 초기 설정이 완료되지 않았다면 비밀번호 설정 화면으로 이동
    if (!isInitialSetupUser) {
      return Routes.signUpPassword;
    }

    // 인증 완료 상태에서 회원가입 또는 로그인 관련 화면에 접근하려는 경우
    // 메인 화면으로 리다이렉트
    if (nowPath == Routes.signIn ||
        nowPath == Routes.signUp ||
        nowPath == Routes.signUpPassword ||
        nowPath == Routes.checkOtp) {
      return Routes.myFiles;
    }

    // 원래 가려던 방향 유지
    return null;
  }



  static String? createProblemRedirect(Object? extra) {
    // 만약 화면 이동간 필요한 데이터가 타입과 일치하지 않는다면,
    // 강제로 문제 생성 처음 화면으로 이동시킵니다.
    if (extra is! OpenAiResponse) {
      return Routes.create;
    }
    return null;
  }

  static String? pdfPreviewRedirect(Object? extra) {
    // 만약 화면 이동간 필요한 데이터가 타입과 일치하지 않는다면,
    // 강제로 문제 생성 처음 화면으로 이동시킵니다.
    if (extra is! Uint8List) {
      return Routes.create;
    }
    return null;
  }

  static String? createTemplateRedirect(Object? extra) {
    // 만약 화면 이동간 필요한 데이터가 타입과 일치하지 않는다면,
    // 강제로 문제 생성 처음 화면으로 이동시킵니다.
    if (extra is! CreateTemplateParams) {
      return Routes.create;
    }
    return null;
  }
}
