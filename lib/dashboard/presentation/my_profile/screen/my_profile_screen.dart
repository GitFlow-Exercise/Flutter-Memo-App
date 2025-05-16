import 'package:flutter/material.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_action.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_state.dart';

class MyProfileScreen extends StatefulWidget {
  final MyProfileState state;
  final void Function(MyProfileAction action) onAction;

  const MyProfileScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
