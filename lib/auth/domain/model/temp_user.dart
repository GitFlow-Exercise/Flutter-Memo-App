import 'package:freezed_annotation/freezed_annotation.dart';

part 'temp_user.freezed.dart';

@freezed
abstract class TempUser with _$TempUser {
  const factory TempUser({
    required String email,
    required String password,
  }) = _TempUser;
}