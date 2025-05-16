import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(myProfileViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(MyProfileEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myProfileViewModelProvider);

    return Scaffold(
      body: MyProfileScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(MyProfileAction action) {
    switch (action) {
      case OnTap():
        debugPrint('tapped onTap');
    }
  }
}
