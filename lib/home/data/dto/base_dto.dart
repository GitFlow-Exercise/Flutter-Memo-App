abstract class BaseDto {
  /// JSON으로 변환하는 메서드
  Map<String, dynamic> toJson();

  /// 고유 식별자 반환
  String? getId();
}
