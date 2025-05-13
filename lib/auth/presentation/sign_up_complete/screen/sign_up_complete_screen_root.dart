import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/sign_up_complete/controller/sign_up_complete_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up_complete/screen/sign_up_complete_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class SignUpCompleteScreenRoot extends ConsumerStatefulWidget {
  const SignUpCompleteScreenRoot({super.key});

  @override
  ConsumerState<SignUpCompleteScreenRoot> createState() =>
      _SignUpCompleteScreenRootState();
}

class _SignUpCompleteScreenRootState
    extends ConsumerState<SignUpCompleteScreenRoot> {
  @override
  Widget build(BuildContext context) {
    return SignUpCompleteScreen(onAction: _handleAction);
  }

  void _handleAction(SignUpCompleteAction action) {
    switch (action) {
      //TODO(ok): 그룹 선택 분기처리 예정
      case OnTapHome():
        context.go(Routes.myFiles);
        break;
    }
  }
}
