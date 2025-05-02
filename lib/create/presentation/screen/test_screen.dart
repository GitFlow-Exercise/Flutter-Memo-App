import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/constants/prompt.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/request/input_content.dart';
import 'package:mongo_ai/create/domain/model/request/message_input.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({super.key});
  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  final _controller = TextEditingController();
  String? _reply;
  bool _loading = false;

  Future<void> _sendPrompt() async {
    final inputText = _controller.text;

    setState(() {
      _loading = true;
      _reply = null;
    });

    // 1) 클라이언트에서 보낼 OpenAI 요청 페이로드를 Map으로 정의
    final body = OpenAiBody(
      input: [
        MessageInput(content: [
          InputContent.text(text: inputText),
        ]),
      ],
      instructions: Prompt.prompt1.detail,
    );
    final resp = await ref.read(createProblemUseCaseProvider).execute(body);

    switch (resp) {
      case Success<OpenAiResponse, AppException>():
        final id = resp.data.id;
        final status = resp.data.status;
        final instructions = resp.data.instructions;
        final outputStatus = resp.data.output[0].status;
        final text = resp.data.output[0].content[0].text;

        // 3) 출력
        print('--- Response Debug ---');
        print('id           : $id');
        print('status       : $status');
        print('instructions : $instructions');
        print('outputStatus : $outputStatus');
        print('text         : $text');
        print('----------------------');
        setState(() {
          _reply = text;
          _loading = false;
        });
      case Error<OpenAiResponse, AppException>():
        setState(() {
          _reply = 'Error Msg: ${resp.error.message}';
          _reply = 'Error: ${resp.error.error}';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edge Fn + OpenAI 예제')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _loading ? '대기 중…' : (_reply ?? '메시지를 입력하고 전송 버튼을 눌러주세요.'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '질문을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loading ? null : _sendPrompt,
              child: const Text('전송'),
            ),
          ],
        ),
      ),
    );
  }
}
