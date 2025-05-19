extension IntExtension on int {
  String formatRemainingTime() {
    final minutes = this ~/ 60;
    final remainingSeconds = this % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}