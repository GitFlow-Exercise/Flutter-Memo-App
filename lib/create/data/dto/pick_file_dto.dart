import 'dart:typed_data';

class PickFileDto {
  String? type;
  String? fileName;
  Uint8List? bytes;

  PickFileDto({
    required this.type,
    required this.fileName,
    required this.bytes,
  });
}