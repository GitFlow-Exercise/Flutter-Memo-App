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
    final body = const OpenAiBody(
      input: [
        MessageInput(
          content: [
            // ------------------------------
            // 텍스트 보내는 예제
            InputContent.text(text: 'text'),

            // ------------------------------
            // 이미지 보내는 예제
            InputContent.image(imageExtension: 'png', base64: '{base64}'),

            // ------------------------------
            // 파일 보내는 예제
            InputContent.file(filename: 'test.pdf', base64: '{base64}'),
          ],
        ),
      ],
      // 이전 AI의 respId 값
      previousResponseId:
          'resp_6815d6a10fb88192b2041a7ae053c9d902023d1f901296d6',
      // AI prompt
      instructions: '내 이름을 이모티콘과 함께 부르며 해당 문제에 대한 clean text를 추출해줘.',
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
      appBar: AppBar(title: const Text('OpenAI 테스트')),
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
