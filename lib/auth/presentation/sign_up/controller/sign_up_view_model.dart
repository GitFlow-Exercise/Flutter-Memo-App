import 'package:flutter/widgets.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_view_model.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel {
  @override
  SignUpState build() {
    return SignUpState(
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      passwordConfirmController: TextEditingController(),
    );
  }

  set isEmailCompleted(bool isEmailCompleted) {
    state = state.copyWith(isEmailCompleted: isEmailCompleted);
  }

  void toggleTermsOfUse() {
    state = state.copyWith(isTermsOfUseChecked: !state.isTermsOfUseChecked);
  }

  Future<bool> checkEmail() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.isEmailExist(
      state.emailController.text,
    );

    switch (result) {
      case Success<bool, AppException>():
        if (result.data) {
          print('이미 존재하는 이메일입니다.');
          return false;
        } else {
          print('사용 가능한 이메일입니다.');
          return true;
        }
      case Error<bool, AppException>():
        print(result.error.message);

        return false;
    }
  }

  Future<bool> signUp() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signUp(
      state.emailController.text,
      state.passwordController.text,
    );

    switch (result) {
      case Success<void, AppException>():
        print('회원가입 성공');
        return true;
      case Error<void, AppException>():
        switch (result.error) {
          case AppException.emailAlreadyExist:
            print(result.error.message);

            break;
          case AppException.unknown:
            print(result.error.message);

            break;
          default:
            print(result.error.message);
        }
        return false;
    }
  }
}
