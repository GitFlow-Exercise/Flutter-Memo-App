import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/create/domain/model/request/input_content.dart';
import 'package:mongo_ai/create/domain/model/request/message_input.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/presentation/create_problem/controller/create_problem_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      backgroundColor: AppColor.white,
      body: state.problem.when(
        data: (value) {
          // ------ Todo ------
          // 다음 화면 라우팅 연결
          // 값이 할당되었다면 프레임 빌드 후 다른 화면으로 이동
          // WidgetsBinding.instance.addPostFrameCallback((_) {});
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state.problemTypes.when(
                data: (value) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(value.length, (index) {
                      final prompt = value[index];
                      final promptName = prompt.name;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            onAction(CreateProblemAction.changeType(prompt));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  state.problemType == prompt
                                      ? AppColor.black
                                      : AppColor.white,
                              border: Border.all(),
                            ),
                            child: Text(
                              promptName,
                              style: TextStyle(
                                color:
                                    state.problemType == prompt
                                        ? AppColor.white
                                        : AppColor.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
                error:
                    (error, stackTrace) =>
                        const Center(child: Text('에러가 발생하였습니다.')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
              const Gap(40),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Clean Text'),
                    // --------------------
                    // TODO 아래 코드가 복잡해서 어떻게 처리할지 추가로 수정할 예정입니다.
                    // Container(
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(border: Border.all()),
                    //   width: MediaQuery.sizeOf(context).width / 3,
                    //   child: Text(state.response!.output[0].content[0].text),
                    // ),
                    const Gap(12),
                    InkWell(
                      onTap: () {
                        onAction(
                          CreateProblemAction.createProblem(
                            OpenAiBody(
                              input: [
                                MessageInput(
                                  content: [InputContent.text(text: '안녕 반가워')],
                                ),
                              ],
                              instructions: '',
                            ),
                          ),
                        );
                      },
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
              ),
            ],
          );
        },
        error: (error, stackTrace) => const Center(child: Text('에러가 발생하였습니다.')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
