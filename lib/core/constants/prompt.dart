import 'package:mongo_ai/core/constants/ai_constant.dart';

// --TODO
// 추후 Prompt 데이터 받아서 enum에 추가하기
// AI Prompt enum을 정의,
// 실질적인 prompt 내용은 'AiConstant' 에 정의해서 사용할 예정
enum Prompt {
  prompt1(AiConstant.prompt1),
  prompt2(''),
  prompt3('');

  final String detail;

  const Prompt(this.detail);
}
