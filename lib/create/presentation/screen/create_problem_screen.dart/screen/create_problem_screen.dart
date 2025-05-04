import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final prompt = state.problemTypes[index];
                final promptName = prompt.name;
                return InkWell(
                  onTap: () {
                    onAction(CreateProblemAction.changeType(prompt));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Text(promptName),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Gap(20);
              },
              itemCount: state.problemTypes.length,
            ),
          ),
          const Gap(40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all()),
                child: Text(state.cleanText),
              ),
              const Gap(12),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(border: Border.all()),
                  child: const Text('문제 만들기'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
