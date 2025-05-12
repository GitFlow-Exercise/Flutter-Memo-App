import 'package:flutter/material.dart';

class AiLoadingView extends StatelessWidget {
  const AiLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      width: double.infinity,
      height: double.infinity,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
