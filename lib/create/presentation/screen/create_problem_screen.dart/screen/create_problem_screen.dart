import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/create/presentation/screen/create_problem_screen.dart/controller/create_problem_state.dart';

import '../controller/create_problem_action.dart';

class CreateProblemScreen extends StatelessWidget {
  final CreateProblemState state;
  final void Function(CreateProblemAction) onAction;

  const CreateProblemScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ...List.generate(state.problemTypes.length, (index) {
            return Container(child: Text(state.problemTypes[index]));
          }),
        ],
      ),
    );
  }
}
