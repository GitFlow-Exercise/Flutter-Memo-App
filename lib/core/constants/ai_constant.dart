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
   - 모든 문제 번호 제거 (예: "34." 삭제)
   - 모든 객관식 보기 제거 (①②③④⑤ 및 설명)
   - 빈칸(______)에 정답 삽입
   - 점수 표시 제거 ([3점] 등)
   - 주석이나 부가 설명 제거 (* conspiracy theory: 음모론 등)
   - 정답 삽입 시 어떠한 표시(볼드체, 기울임체 등)도 하지 않음
''';
}
