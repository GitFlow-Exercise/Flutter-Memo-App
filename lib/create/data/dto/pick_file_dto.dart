import 'dart:typed_data';

class PickFileDto {
  String? type;
  String? fileName;
  String? fileExtension;
  Uint8List? bytes;

  PickFileDto({
    this.type,
    this.fileName,
    this.fileExtension,
    this.bytes,
  });
}