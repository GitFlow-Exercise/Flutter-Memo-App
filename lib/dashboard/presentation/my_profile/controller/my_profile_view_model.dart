import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/event/app_event.dart';
import 'package:mongo_ai/core/event/app_event_provider.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_profile_view_model.g.dart';

@riverpod
class MyProfileViewModel extends _$MyProfileViewModel {
  @override
  MyProfileState build() {
    final userNameTextController = TextEditingController();

    ref.onDispose(() {
      userNameTextController.dispose();
    });

    return MyProfileState(userNameController: userNameTextController);
  }

  // 사용자 프로필 정보 가져오기
  Future<void> fetchUserProfile() async {
    state = state.copyWith(data: const AsyncValue.loading());

    final repository = ref.read(userProfileRepositoryProvider);
    final result = await repository.getCurrentUserProfile();

    switch (result) {
      case Success(data: final profile):
        // 데이터 로드 성공 시 상태 업데이트
        state = state.copyWith(data: AsyncValue.data(profile));
        break;
      case Error(error: final error):
        // 에러 발생 시 상태 업데이트
        state = state.copyWith(
          data: AsyncValue.error(error, StackTrace.current),
        );
        // 에러 메시지 이벤트 발생
        _readyForSnackBar(error.message);
        break;
    }
  }

  // 사용자 이름 업데이트
  Future<void> updateUserName(String name) async {
    final user = state.data.value;

    if (user == null) {
      _readyForSnackBar('사용자 정보를 가져오는 중 오류가 발생했습니다.');
      return;
    }

    final repository = ref.read(userProfileRepositoryProvider);
    final result = await repository.modifyUserName(user.userId, name);

    switch (result) {
      case Success():
        final updatedUser = user.copyWith(userName: name);

        state = state.copyWith(data: AsyncValue.data(updatedUser));
        _readyForSnackBar('닉네임 변경을 완료했습니다.');
        _updateDashboardUserName(updatedUser);
        break;
      case Error(error: final error):
        state = state.copyWith(
          data: AsyncValue.error(error, StackTrace.current),
        );
        _readyForSnackBar(error.message);
        break;
    }
  }

  // 대시보드 유저 이름 업데이트
  Future<void> _updateDashboardUserName(UserProfile userProfile) async {
    await ref
        .read(dashboardViewModelProvider.notifier)
        .updateUserProfile(userProfile);
  }

  // 로그아웃
  Future<void> logout() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.signOut();

      switch (result) {
        case Success():
          _readyForSnackBar('로그아웃 되었습니다.');

          navigateSignIn();
          break;
        case Error(error: final error):
          _readyForSnackBar(error.message);
          break;
      }
    } catch (e) {
      _readyForSnackBar('로그아웃 중 오류가 발생했습니다.');
    }
  }

  // 회원 탈퇴 처리
  Future<void> deleteAccount() async {
    final authRepository = ref.read(authRepositoryProvider);

    final userId = authRepository.userId;

    if (userId == null) {
      _readyForSnackBar('로그인된 사용자 정보를 찾을 수 없습니다.');
      return;
    }

    final result = await authRepository.deleteUser(userId);

    switch (result) {
      case Success():
        await authRepository.signOut();
        _readyForSnackBar('회원 탈퇴가 완료되었습니다.');

        navigateSignIn();
        return;
      case Error(error: final error):
        _readyForSnackBar(error.message);
        return;
    }
  }

  // 하단 스낵바 출력
  void _readyForSnackBar(String message) {
    ref
        .read(appEventProvider.notifier)
        .addEvent(AppEventState.showSnackBar(message: message));
  }

  void navigateSignIn() {
    ref
        .read(appEventProvider.notifier)
        .addEvent(const AppEventState.navigate(routeName: Routes.signIn));
  }
}
