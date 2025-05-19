extension StringExtension on String {

  // 앞의 2자리만 보여주고 나머지는 마스킹
  String get maskedEmail {
    if (isEmpty) return '';

    final parts = split('@');
    if (parts.length != 2) return this;

    String username = parts[0];
    String domain = parts[1];

    if (username.length > 2) {
      String visiblePart = username.substring(0, 2);
      String maskedPart = '•' * (username.length - 2);
      return '$visiblePart$maskedPart@$domain';
    }

    return this;
  }
}
