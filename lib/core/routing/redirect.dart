import 'package:mongo_ai/core/routing/routes.dart';

abstract class AppRedirect {
  // 인증 관련 redirect 로직입니다.
  static String? authRedirect({
    required bool isAuthenticated,
    required String? nowPath,
  }) {
    // 인증이 없다면 로그인 화면으로 강제 이동
    if (!isAuthenticated) {
      // 만약 인증이 되지 않은 상태이지만,
      // 회원가입을 하려는 유저라면
      // 정상적으로 이동하도록 설정
      // ------------
      // TODO: 추후 비밀번호 재설정화면도 추가해아합니다.
      if (nowPath == Routes.signUp) {
        return null;
      }
      return Routes.signIn;
    }
    // 유저 정보가 존재하고,
    // 현재 화면이 로그인 화면이거나 회원가입 화면이라면
    // 강제로 홈 화면으로 이동
    if (nowPath == Routes.signIn || nowPath == Routes.signUp) {
      return Routes.home;
    }
    // 원래 가려던 방향 null
    return null;
  }
}
