import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/domain/model/create_template_params.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

abstract class AppRedirect {
  static String? authRedirect({
    required bool isAuthenticated,
    required bool isInitialSetupUser,
    required bool isSelectTeam,
    required String? nowPath,
    required Object? extra,
  }) {
    // 1. 미인증 사용자 처리 (isAuthenticated = false)
    if (!isAuthenticated) {
      // Sign In과 Sign Up은 항상 접근 가능
      if (nowPath == Routes.signIn || nowPath == Routes.signUp) {
        return null;
      }

      // otp확인은 extra 값이 있어야 함
      if (nowPath == Routes.checkOtp && extra is String) {
        return null;
      }

      // Check OTP가 extra와 함께 접근한 경우는 정상 진행
      return Routes.signIn;
    }

    // 2. 인증은 됐지만 초기 설정이 안 된 경우 (isAuthenticated = true, isInitialSetupUser = false)
    if (!isInitialSetupUser) {
      // 비밀번호 설정, 완료 화면은 extra가 있어야 함
      if (nowPath == Routes.signUpPassword && extra is String ||
          nowPath == Routes.signUpComplete && extra is String) {
        return null;
      }
      // 그 외 모든 페이지는 비밀번호 설정으로 리다이렉트
      return Routes.signUpPassword;
    }

    // 이 조건 사이의 complete 화면은 예외
    if (nowPath == Routes.signUpComplete) {
      return null;
    }

    // 3. 인증은 됐고 초기설정은 됐지만 팀 설정이 안됐을 경우
    if (!isSelectTeam) {
      return Routes.selectTeam;
    }

    // 4. 완전히 인증된 사용자 (isAuthenticated = true, isInitialSetupUser = true)
    // 회원가입/로그인 관련 화면 접근 시도는 메인 화면으로 리다이렉트
    // 완료 화면은 예외
    if (nowPath == Routes.signIn ||
        nowPath == Routes.signUp ||
        nowPath == Routes.checkOtp ||
        nowPath == Routes.signUpPassword ||
        nowPath == Routes.selectTeam) {
      return Routes.myFiles;
    }

    // 그 외 모든 경우는 원래 가려던 경로 유지
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

  static String? createCompleteRedirect(Object? extra) {
    // 만약 화면 이동간 필요한 데이터가 타입과 일치하지 않는다면,
    // 강제로 문제 생성 처음 화면으로 이동시킵니다.
    if (extra is! List<Problem>) {
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
