import 'dart:typed_data';

import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/domain/model/create_workbook_params.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

abstract class AppRedirect {
  // 인증 관련 redirect 로직입니다.
  static String? authRedirect({
    required bool isAuthenticated,
    required bool isInitialSetupComplete,
    required String? nowPath,
    required Object? extra
  }) {
    // 인증이 없다면 로그인 화면으로 강제 이동
    if (!isAuthenticated) {
      // 만약 sign-up 등의 중간 단계에서 세션 만료, 새로고침 등으로 extra가 손실되었다면
      // 로그인 화면으로 다시 이동
      if (nowPath != Routes.signUp && extra is! String) {
        return Routes.signIn;
      }
      // 만약 인증이 되지 않은 상태이지만,
      // 회원가입을 하려는 유저라면
      // 정상적으로 이동하도록 설정
      // ------------
      // TODO: 추후 비밀번호 재설정화면도 추가해아합니다.
      if (nowPath == Routes.signUp || nowPath == Routes.signUpPassword || nowPath == Routes.checkOtp) {
        return null;
      }
      return Routes.signIn;
    }
    // 만약 인증은 되었지만(OTP를 기입했지만)
    // 패스워드 기입이 안됐을 경우 패스워드 입력 화면으로 이동
    if (!isInitialSetupComplete) {
      return Routes.signUpPassword;
    }

    // 유저 정보가 존재하고,
    // 현재 화면이 로그인 화면이거나 회원가입 화면이라면
    // 강제로 홈 화면으로 이동
    if (nowPath == Routes.signIn || nowPath == Routes.signUp || nowPath == Routes.signUpPassword || nowPath == Routes.checkOtp) {
      return Routes.myFiles;
    }
    // 원래 가려던 방향 null
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
