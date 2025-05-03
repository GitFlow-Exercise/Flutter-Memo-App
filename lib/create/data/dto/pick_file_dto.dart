import 'dart:typed_data';

class PickFileDto {
  String? type;
  String? fileName;
  String? extension;
  Uint8List? bytes;

  PickFileDto({
    required this.type,
    required this.fileName,
    required this.extension,
    required this.bytes,
  });
}