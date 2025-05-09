import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_template_event.freezed.dart';

@freezed
sealed class CreateTemplateEvent with _$CreateTemplateEvent {
  const factory CreateTemplateEvent.showSnackBar(String message) = ShowSnackBar;
}