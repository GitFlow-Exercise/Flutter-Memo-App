// AI 관련 상수 텍스트들 정의
abstract class AiConstant {
  // invoke function name
  static const String invokeFunction = 'clever-handler';

  // Data Type
  static const String inputText = 'input_text';
  static const String inputImage = 'input_image';
  static const String inputFile = 'input_file';

  // AI Model
  static const String aiModel = 'gpt-4.1';

  // role
  static const String role = 'user';

  // status
  static const String completed = 'completed';

  static const String cleanTextPrompt = '''
**Clean Text 생성 규칙**
   - 문제의 요지나 정답을 출력하지 말고, 반드시 아래 규칙에 따라 지문만 정제하세요.
   - 모든 문제 번호 제거 (예: "34." 삭제)
   - 각 문제의 객관식 보기(①, ②, ③, ④, ⑤로 시작하는 문장 전체)를 완전히 삭제하세요.
   - 지문 내 빈칸()이 있으면, 해당 문제의 정답을 빈칸에 그대로 입력하세요.
   - 점수 표시 제거 ([3점] 등)
   - 주석이나 부가 설명 제거 (* conspiracy theory: 음모론 등)
   - 정답 삽입 시 어떠한 표시(볼드체, 기울임체 등)도 하지 않음.
''';
}
