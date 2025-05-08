import 'package:freezed_annotation/freezed_annotation.dart';

part 'team.freezed.dart';

@freezed
abstract class Team with _$Team {
  const factory Team({
    required int teamId,
    required String teamName,
    String? teamImage,
  }) = _Team;
}