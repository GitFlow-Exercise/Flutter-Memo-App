import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_action.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_state.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/screen/landing_header.dart';

class LandingShellScreen extends StatelessWidget {
  final LandingShellState state;
  final void Function(LandingShellAction action) onAction;
  final StatefulNavigationShell navigationShell;

  const LandingShellScreen({
    super.key,
    required this.navigationShell,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LandingHeader(state: state, onAction: onAction),

          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
