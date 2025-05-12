import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_state.dart';

class SignUpPasswordScreen extends StatefulWidget {
  final AsyncValue<SignUpPasswordState> state;
  final void Function(SignUpPasswordAction action) onAction;

  const SignUpPasswordScreen({super.key, required this.state, required this.onAction});

  @override
  State<SignUpPasswordScreen> createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}