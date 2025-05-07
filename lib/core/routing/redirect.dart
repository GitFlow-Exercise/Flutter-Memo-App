import 'package:mongo_ai/core/routing/routes.dart';

abstract class AppRedirect {
  static String? authRedirect(bool isAuthenticated) {
    // 인증이 없다면 로그인 화면으로 강제 이동
    if (!isAuthenticated) {
      return Routes.signIn;
    }
    // 원래 가려던 방향 null
    return null;
  }
}
