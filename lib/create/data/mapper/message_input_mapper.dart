import 'package:mongo_ai/create/data/dto/message_input_dto.dart';
import 'package:mongo_ai/create/data/mapper/input_content_mapper.dart';
import 'package:mongo_ai/create/domain/model/message_input.dart';

extension MessageInputMapper on MessageInput {
  MessageInputDto toMessageInputDto() {
    return MessageInputDto(
      role: role,
      content: content.map((e) => e.toInputContentDto()).toList(),
    );
  }
}
