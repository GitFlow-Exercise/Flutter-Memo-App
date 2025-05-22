import 'package:mongo_ai/create/data/dto/problem_dto.dart';
import 'package:mongo_ai/create/domain/model/problem.dart';

extension ProblemMapper on ProblemDto {
  Problem toProblem() {
    return Problem(
      problemType: problemLabel,
      question: question,
      passage: passage,
      options: options,
      number: 0,
      promptDetail: '',
      requestContent: '',
      cleanText: '',
    );
  }
}

extension ProblemDtoMapper on Problem {
  ProblemDto toProblemDto(int  workbookId) {
    return ProblemDto(
      workbookId: workbookId,
      problemLabel: problemType,
      question: question,
      passage: passage,
      options: options,
    );
  }
}
