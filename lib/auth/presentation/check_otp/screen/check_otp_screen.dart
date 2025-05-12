import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_action.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_state.dart';

class CheckOtpScreen extends StatefulWidget {
  final AsyncValue<CheckOtpState> state;
  final void Function(CheckOtpAction action) onAction;

  const CheckOtpScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<CheckOtpScreen> createState() => _CheckOtpScreenState();
}

class _CheckOtpScreenState extends State<CheckOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
