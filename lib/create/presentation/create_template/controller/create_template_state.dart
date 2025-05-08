import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'create_template_state.freezed.dart';

@freezed
abstract class CreateTemplateState with _$CreateTemplateState {
  const factory CreateTemplateState({
    @Default(AsyncValue.data(null)) AsyncValue<OpenAiResponse?> problem,
  }) = _CreateTemplateState;
}
