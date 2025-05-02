import 'package:mongo_ai/core/constants/ai_constant.dart';

// --TODO
// 추후 Prompt 데이터 받아서 enum에 추가하기
enum Prompt {
  prompt1(AiConstant.prompt1),
  prompt2(''),
  prompt3('');

  final String detail;

  const Prompt(this.detail);
}
