import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_event.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sign_in_view_model.g.dart';

@riverpod
class SignInViewModel extends _$SignInViewModel {
  final _eventController = StreamController<SignInEvent>();

  Stream<SignInEvent> get eventStream => _eventController.stream;

  StreamSubscription<AuthState>? _authSubscription;

  @override
  SignInState build() {
    // 인증 상태 구독 설정
    _setupAuthListener();

    // 메모리 누수 방지를 위한 해제 로직
    ref.onDispose(() {
      _authSubscription?.cancel();
      _eventController.close();
    });

    return SignInState(
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
    );
  }

  //TODO: 주석 추가 필요
  void _setupAuthListener() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn) {
        final user = session?.user;
        final provider = user?.appMetadata['provider'] as String?;


        if (provider == 'google') {
          _handleGoogleSignIn(user);
        } else {
          _eventController.add(const SignInEvent.navigateToHome());
        }
      }
    });
  }

  // Google 로그인 처리
  Future<void> _handleGoogleSignIn(User? user) async {
    if (user == null) return;
    final authRepository = ref.read(authRepositoryProvider);

    final isUserExisting = authRepository.checkMetadata(
      'is_initial_setup_user',
    );
    if (isUserExisting) {
      _eventController.add(const SignInEvent.navigateToHome());
    } else {
      try {
        await authRepository.saveUser();
        _eventController.add(const SignInEvent.navigateToSelectTeam());
      } catch (e) {
        _eventController.add(
          const SignInEvent.showSnackBar('구글 로그인 중 오류가 발생했습니다.'),
        );
      }
    }
  }

  // Google 로그인 시작
  Future<void> googleSignIn() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signInWithGoogle();

      // 이후 처리는 _setupAuthListener에서 수행
      // 여기서 결과 처리는 하지 않음
    } catch (e) {
      _eventController.add(
        const SignInEvent.showSnackBar('Google 로그인을 시작할 수 없습니다.'),
      );
    }
  }

  // 이메일 로그인 (기존 코드 유지)
  Future<SignInState> login() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signIn(
      state.emailController.text,
      state.passwordController.text,
    );

    switch (result) {
      case Success<void, AppException>():
        return state.copyWith(isLoginRejected: false);
      case Error<void, AppException>():
        _eventController.add(SignInEvent.showSnackBar(result.error.message));
        return state.copyWith(isLoginRejected: true);
    }
  }
}
