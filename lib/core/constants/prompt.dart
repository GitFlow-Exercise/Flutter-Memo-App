import 'package:mongo_ai/core/constants/ai_constant.dart';

enum Prompt {
  prompt1(AiConstant.prompt1),
  prompt2(''),
  prompt3('');

  final String detail;

  const Prompt(this.detail);
}
