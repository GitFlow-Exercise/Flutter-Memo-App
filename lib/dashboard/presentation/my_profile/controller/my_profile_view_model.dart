import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_event.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_profile_view_model.g.dart';

@riverpod
class MyProfileViewModel extends _$MyProfileViewModel {
  final _eventController = StreamController<MyProfileEvent>.broadcast();

  Stream<MyProfileEvent> get eventStream => _eventController.stream;

  @override
  MyProfileState build() {
    debugPrint('my_profile_view_model.dart: build() 호출 - Line 18');

    ref.onDispose(() {
      _eventController.close();
    });

    final state = const MyProfileState();

    Future.microtask(_fetchUserProfile);

    return state;
  }

  // 사용자 프로필 정보 가져오기
  Future<void> _fetchUserProfile() async {
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
        _eventController.add(MyProfileEvent.showSnackBar(error.message));
        break;
    }
  }

  // 사용자 이름 업데이트
  Future<void> updateUserName(String name) async {
    final user = state.data.value;

    if (user == null) {
      _eventController.add(
        const MyProfileEvent.showSnackBar('사용자 정보를 가져오는 중 오류가 발생했습니다.'),
      );
      return;
    }

    final repository = ref.read(userProfileRepositoryProvider);
    final result = await repository.modifyUserName(user.userId, name);

    switch (result) {
      case Success():
        state = state.copyWith(
          data: AsyncValue.data(user.copyWith(userName: name)),
        );
        _eventController.add(const MyProfileEvent.showSnackBar('닉네임 변경을 완료했습니다.'));
        break;
      case Error(error: final error):
        state = state.copyWith(
          data: AsyncValue.error(error, StackTrace.current),
        );
        _eventController.add(MyProfileEvent.showSnackBar(error.message));
        break;
    }
  }

  // 로그아웃 처리
  Future<void> logout() async {
    debugPrint('my_profile_view_model.dart: logout() 호출 - Line 78');

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.signOut();

      switch (result) {
        case Success():
          _eventController.add(
            const MyProfileEvent.showSnackBar('로그아웃 되었습니다.'),
          );
          debugPrint('my_profile_view_model.dart: 로그아웃 성공 - Line 88');
          break;
        case Error(error: final error):
          _eventController.add(MyProfileEvent.showSnackBar(error.message));
          debugPrint(
            'my_profile_view_model.dart: 로그아웃 오류 - ${error.message} - Line 91',
          );
          break;
      }
    } catch (e) {
      _eventController.add(
        const MyProfileEvent.showSnackBar('로그아웃 중 오류가 발생했습니다.'),
      );
      debugPrint('my_profile_view_model.dart: 예상치 못한 로그아웃 오류 - $e - Line 98');
    }
  }

  // 회원 탈퇴 처리
  Future<void> deleteAccount() async {
    debugPrint('my_profile_view_model.dart: deleteAccount() 호출 - Line 103');

    // 실제 회원 탈퇴 로직 구현 필요
    _eventController.add(
      const MyProfileEvent.showSnackBar('회원 탈퇴 기능은 아직 구현되지 않았습니다.'),
    );
  }
}
