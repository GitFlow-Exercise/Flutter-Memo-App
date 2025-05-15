import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_action.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_event.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_view_model.dart';
import 'package:mongo_ai/auth/presentation/sign_in/screen/sign_in_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class SignInScreenRoot extends ConsumerStatefulWidget {
  const SignInScreenRoot({super.key});

  @override
  ConsumerState<SignInScreenRoot> createState() => _SignInScreenRootState();
}

class _SignInScreenRootState extends ConsumerState<SignInScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(signInViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(SignInEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInViewModelProvider);
    return SignInScreen(
      state: state,
      onAction: (action) => _handleAction(action, ref, context),
    );
  }

  void _handleAction(
    SignInAction action,
    WidgetRef ref,
    BuildContext context,
  ) async {
    final viewModel = ref.watch(signInViewModelProvider.notifier);

    switch (action) {
      case OnTapLogin():
        await viewModel.login();
      case OnTapSignUp():
        context.go(Routes.signUp);
    }
  }
}
