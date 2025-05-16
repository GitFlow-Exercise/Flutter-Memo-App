import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart'; // 로케일 데이터 초기화 import 추가
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_action.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_event.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/screen/my_profile_screen.dart';

class MyProfileScreenRoot extends ConsumerStatefulWidget {
  const MyProfileScreenRoot({super.key});

  @override
  ConsumerState<MyProfileScreenRoot> createState() =>
      _MyProfileScreenRootState();
}

class _MyProfileScreenRootState extends ConsumerState<MyProfileScreenRoot> {
  StreamSubscription? _subscription;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    debugPrint('my_profile_screen_root.dart: initState - Line 22');

    // 앱 초기화 시 한국어 로케일 데이터 초기화
    initializeDateFormatting('ko_KR', null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 한 번만 초기화하도록 플래그 사용
    if (!_isInitialized) {
      _isInitialized = true;

      // 이벤트 리스너 설정을 비동기로 처리
      Future.microtask(() {
        if (mounted) {
          final viewModel = ref.read(myProfileViewModelProvider.notifier);
          _subscription = viewModel.eventStream.listen(_handleEvent);
        }
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    debugPrint('my_profile_screen_root.dart: dispose - Line 43');
    super.dispose();
  }

  void _handleEvent(MyProfileEvent event) {
    debugPrint('my_profile_screen_root.dart: _handleEvent - Line 34');

    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('my_profile_screen_root.dart: build - Line 45');

    final state = ref.watch(myProfileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: MyProfileScreen(
        state: state,
        onAction: _handleAction,
      ),
    );
  }

  void _handleAction(MyProfileAction action) {
    debugPrint('my_profile_screen_root.dart: _handleAction - Line 61');

    final viewModel = ref.read(myProfileViewModelProvider.notifier);

    switch (action) {
      case OnTap():
        debugPrint('my_profile_screen_root.dart: OnTap 액션 처리 - Line 66');
        break;
      case OnUpdateProfile(name: final name):
        viewModel.updateUserName(name);
        break;
      case OnLogout():
        debugPrint('my_profile_screen_root.dart: OnLogout 액션 처리 - Line 72');
        // 뷰모델의 logout 메서드 호출
        // viewModel.logout();
        break;
      case OnDeleteAccount():
        debugPrint('my_profile_screen_root.dart: OnDeleteAccount 액션 처리 - Line 76');
        // 뷰모델의 deleteAccount 메서드 호출
        // viewModel.deleteAccount();
        break;
    }
  }
}