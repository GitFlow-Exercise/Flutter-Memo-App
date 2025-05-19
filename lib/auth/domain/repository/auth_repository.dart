import 'package:flutter/foundation.dart';
import 'package:mongo_ai/auth/domain/model/auth_state_change.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 인증 관련 기능을 제공하는 Repository 추상 클래스
/// ChangeNotifier를 상속받아 활용
abstract class AuthRepository extends ChangeNotifier {
  /// 현재 사용자의 인증 상태를 반환합니다.
  /// true: 로그인 되어 있음, false: 로그인 되어 있지 않음
  bool get isAuthenticated;

  /// 사용자가 초기 설정을 완료했는지 여부를 반환합니다.(이메일 가입 시 비밀번호 설정 완료)
  /// true: 초기 설정 완료, false: 초기 설정 미완료
  bool get isInitialSetupUser;

  /// 사용자가 팀 선택을 완료했는지 여부를 반환합니다.
  /// true: 팀 선택 완료, false: 팀 선택 미완료
  bool get isSelectTeam;

  /// 현재 로그인된 사용자의 ID를 반환합니다.
  /// 로그인 되어 있지 않은 경우 null을 반환합니다.
  String? get userId;

  /// 인증 상태 변경 스트림을 반환합니다.
  /// 인증 상태(로그인, 로그아웃 등) 변경 시 이벤트가 발생합니다.
  Stream<AuthState> get authStateChanges;

  /// 인증 상태 변경 이벤트를 수신할 리스너를 등록합니다.
  ///
  /// [listener] 인증 상태 변경 시 호출될 콜백 함수
  void addAuthStateListener(void Function(AuthStateChange) listener);

  /// 등록된 인증 상태 변경 리스너를 제거합니다.
  ///
  /// [listener] 제거할 리스너 콜백 함수
  void removeAuthStateListener(void Function(AuthStateChange) listener);

  /// Google 로그인 후 사용자 정보 처리를 담당합니다.
  /// 초기 설정 여부 확인 및 사용자 정보 저장 등의 작업을 수행합니다.
  ///
  /// [user] 구글 로그인으로 인증된 사용자 정보
  Future<Result<void, AppException>> handleGoogleSignIn(User? user);

  /// 사용자의 메타데이터 존재 여부를 확인합니다.
  ///
  /// [key] 확인할 메타데이터 키
  /// 존재하면 true, 존재하지 않으면 false 반환
  bool checkMetadata(String key);

  /// 이메일과 비밀번호를 사용하여 로그인합니다.
  ///
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  Future<Result<void, AppException>> signIn(String email, String password);

  /// Google 계정을 사용하여 로그인합니다.
  Future<Result<void, AppException>> signInWithGoogle();

  /// 이메일과 비밀번호로 회원가입을 진행합니다.
  ///
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  Future<Result<void, AppException>> signUp(String email, String password);

  /// 현재 로그인된 사용자를 로그아웃합니다.
  Future<Result<void, AppException>> signOut();

  /// 사용자 계정을 삭제합니다.
  ///
  /// [id] 삭제할 사용자의 ID
  Future<Result<void, AppException>> deleteUser(String id);

  /// 이메일 존재 여부를 확인합니다.
  ///
  /// [email] 확인할 이메일
  Future<Result<bool, AppException>> isEmailExist(String email);

  /// 현재 사용자 정보를 저장합니다.
  /// 초기 설정 완료 메타데이터도 함께 업데이트합니다.
  Future<Result<void, AppException>> saveUser();

  /// 비밀번호 재설정을 위한 OTP(일회용 비밀번호)를 이메일로 전송합니다.
  ///
  /// [email] OTP를 전송할 이메일
  Future<Result<void, AppException>> sendOtp(String email);

  /// 이메일 인증을 위한 OTP를 검증합니다.
  ///
  /// [email] 인증할 이메일
  /// [otp] 이메일로 받은 OTP 코드
  Future<Result<void, AppException>> verifyEmailOtp(String email, String otp);

  /// 매직 링크 인증을 위한 OTP를 검증합니다.
  ///
  /// [email] 인증할 이메일
  /// [otp] 매직 링크로 받은 OTP 코드
  Future<Result<void, AppException>> verifyMagicLinkOtp(
    String email,
    String otp,
  );

  /// 비밀번호를 재설정합니다.
  ///
  /// [password] 새로운 비밀번호
  Future<Result<void, AppException>> resetPassword(String password);

  /// 현재 로그인된 사용자의 이메일을 가져옵니다.
  ///
  Future<Result<String, AppException>> getCurrentUserEmail();

  /// 팀 선택 완료 메타데이터를 설정합니다.
  Future<Result<void, AppException>> setSelectTeamMetadata();

  /// 현재 사용자의 인증 제공자(구글, 이메일/비밀번호 등)를 반환합니다.
  ///
  /// 로그인되어 있지 않거나 제공자 정보가 없는 경우 null 반환
  String? getUserProvider();

  /// 현재 선택된 팀의 ID를 저장합니다.
  ///
  /// 팀 선택이 끝나면 이 메서드를 호출해야 합니다.
  Future<Result<void, AppException>> saveSelectedTeamId(int teamId);

  /// 마지막으로 선택한 팀의 ID를 가져옵니다.
  int? getSelectedTeamId();
}
