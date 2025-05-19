// import 'package:flutter_test/flutter_test.dart';
// import '../../../core/di/test_di.dart';
// import 'package:mongo_ai/core/exception/app_exception.dart';
// import 'package:mongo_ai/core/result/result.dart';
// import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
// import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
// import 'package:mongo_ai/create/domain/use_case/create_problem_use_case.dart';

// void main() {
//   late CreateProblemUseCase createProblemUseCase;

//   setUpAll(() {
//     mockdDISetup();
//     createProblemUseCase = mockLocator();
//   });

//   test('open ai response test', () async {
//     final body = OpenAiBody(input: [], instructions: 'instructions');
//     final result = await createProblemUseCase.execute(body);

//     switch (result) {
//       case Success<OpenAiResponse, AppException>():
//         expect(result.data, isA<OpenAiResponse>());

//         expect(result.data.instructions, equals(body.instructions));
//       case Error<OpenAiResponse, AppException>():
//         expect(result, isA<Error<OpenAiResponse, AppException>>());
//     }
//   });
// }
