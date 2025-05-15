import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_complete_event.freezed.dart';

@freezed
sealed class CreateCompleteEvent with _$CreateCompleteEvent {
  const factory CreateCompleteEvent.showSnackBar(String message) = ShowSnackBar;
}
