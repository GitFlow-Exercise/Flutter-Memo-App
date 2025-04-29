import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_app/home/presentation/home_action.dart';

import 'home_event.dart';
import 'home_screen.dart';
import 'home_view_model.dart';

class HomeScreenRoot extends ConsumerStatefulWidget {
  const HomeScreenRoot({super.key});

  @override
  ConsumerState<HomeScreenRoot> createState() => _HomeScreenRootState();
}

class _HomeScreenRootState extends ConsumerState<HomeScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(homeViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);

      _handleAction(const HomeAction.loadHomeInfo());
    });
  }

  // 1회성 이벤트 처리 메서드
  void _handleEvent(HomeEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(body: HomeScreen(state: state, onAction: _handleAction));
  }

  Future<void> _handleAction(HomeAction action) async {
    final viewModel = ref.watch(homeViewModelProvider.notifier);

    switch (action) {
      case LoadHomeInfo():
        await viewModel.loadHomeInfo();
      case Refresh():
        await viewModel.refreshHomeInfo();
      case OnTapDetail():
        _onTapDetail();
    }
  }

  void _onTapDetail() {
    debugPrint('tapped onTapDetail');
  }
}
