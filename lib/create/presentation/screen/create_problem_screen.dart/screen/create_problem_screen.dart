import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/create/presentation/screen/create_problem_screen.dart/controller/create_problem_state.dart';

import '../controller/create_problem_action.dart';

class CreateProblemScreen extends ConsumerStatefulWidget {
  final CreateProblemState state;
  final void Function(CreateProblemAction) onAction;

  const CreateProblemScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  ConsumerState<CreateProblemScreen> createState() =>
      _CreateProblemScreenState();
}

class _CreateProblemScreenState extends ConsumerState<CreateProblemScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Column(children: []));
  }
}
