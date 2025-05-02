import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SignUpCompleteScreen extends StatelessWidget {
  final VoidCallback onTapHome;
  const SignUpCompleteScreen({super.key, required this.onTapHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.2,
              height: 60,
              color: Colors.grey,
              alignment: Alignment.center,
              child: const Text(
                'LOGO',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Gap(55),
            const Text(
              '회원가입 완료!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const Gap(15),
            const Text(
              '회원가입이 완료되었습니다.\n몽고와 함께 수업 자료를 빠르게 만들어보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
            const Gap(50),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.25,
              height: 50,
              child: ElevatedButton(
                onPressed: onTapHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.5),
                ),
                child: const Text('몽고 사용하러 가기', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
