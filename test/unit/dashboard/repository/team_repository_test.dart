import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/domain/repository/team_repository.dart';
import '../../../core/di/test_di.dart';

void main() {
  late TeamRepository teamRepository;

  const sampleTeamName = '팀 테스트';
  const sampleTeamImage = 'https://example.com/image.png';

  setUpAll(() {
    mockdDISetup();
    teamRepository = mockLocator();
  });

  test('getTeamsByCurrentUser test', () async {
    final result = await teamRepository.getTeamsByCurrentUser();

    switch (result) {
      case Success<List<Team>, AppException>():
        expect(result.data, isNotEmpty);
        for (final t in result.data) {
          expect(t, isA<Team>());
        }
        break;
      case Error<List<Team>, AppException>():
        expect(result, isA<Error<List<Team>, AppException>>());
        break;
    }
  });

  test('getAllTeams test', () async {
    final result = await teamRepository.getAllTeams();

    switch (result) {
      case Success<List<Team>, AppException>():
        expect(result.data, isNotEmpty);
        for (final t in result.data) {
          expect(t, isA<Team>());
        }
        break;
      case Error<List<Team>, AppException>():
        expect(result, isA<Error<List<Team>, AppException>>());
        break;
    }
  });

  test('createTeam test', () async {
    final result = await teamRepository.createTeam(
      sampleTeamName,
      sampleTeamImage,
    );

    switch (result) {
      case Success<Team, AppException>():
        final t = result.data;
        expect(t, isA<Team>());
        expect(t.teamName, equals(sampleTeamName));
        expect(t.teamImage, equals(sampleTeamImage));
        break;
      case Error<Team, AppException>():
        expect(result, isA<Error<Team, AppException>>());
        break;
    }
  });
}
