import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_template_action.freezed.dart';

@freezed
sealed class CreateTemplateAction with _$CreateTemplateAction {
  const factory CreateTemplateAction.onTap() = OnTap;
}