import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class PriceCard extends StatelessWidget {
  final String title;
  final String price;
  final String priceSubtext;
  final String userType;
  final List<String> features;
  final String buttonText;
  final bool isHighlighted;
  final bool isRecommended;
  final bool? isPremium;
  final Function() onButtonPressed;

  const PriceCard({
    super.key,
    required this.title,
    required this.price,
    this.priceSubtext = '',
    required this.userType,
    required this.features,
    required this.buttonText,
    this.isHighlighted = false,
    this.isRecommended = false,
    required this.onButtonPressed,
    this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    final userTypeBgColor =
        isHighlighted
            ? Colors.white.withValues(alpha: 0.2)
            : AppColor.lightBlue;

    final userTypeTextColor =
        isHighlighted ? AppColor.white : AppColor.mediumGray;

    final titleTextColor = isHighlighted ? AppColor.white : AppColor.deepBlack;

    final featureTextColor =
        isHighlighted
            ? AppColor.white.withValues(alpha: 0.9)
            : AppColor.mediumGray;

    final checkIconColor =
        isHighlighted ? AppColor.secondary : AppColor.primary;

    final cardColor = isHighlighted ? AppColor.primary : AppColor.white;

    final cardBorderColor =
        isHighlighted ? AppColor.primary : AppColor.lightGrayBorder;

    final buttonBorderColor =
        isHighlighted ? Colors.transparent : AppColor.primary;

    final cardShadow =
        isHighlighted
            ? [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.1),
                offset: const Offset(0, 10),
                blurRadius: 15,
              ),
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.1),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ]
            : [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.1),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 380,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cardBorderColor, width: 1),
            boxShadow: cardShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목 및 가격
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                price,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: titleTextColor,
                                ),
                              ),
                              if (priceSubtext.isNotEmpty)
                                Text(
                                  priceSubtext,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: titleTextColor,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 사용자 유형 태그
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: userTypeBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    userType,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: userTypeTextColor,
                    ),
                  ),
                ),

                // 설명 텍스트
                const SizedBox(height: 24),
                Text(
                  '대부분의 비즈니스에서 필요로 하는 기능',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: featureTextColor,
                  ),
                ),

                // 구분선
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color:
                      isHighlighted
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppColor.lightGrayBorder,
                ),

                // 기능 목록
                const SizedBox(height: 24),
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: checkIconColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: featureTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 버튼
                const SizedBox(height: 32),
                if (buttonText != '사용 중' || isHighlighted || isPremium == false)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isHighlighted ? AppColor.white : cardColor,
                        foregroundColor: AppColor.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: buttonBorderColor, width: 2),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              isHighlighted
                                  ? AppColor.primary
                                  : AppColor.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // 추천 배지
        if (isRecommended)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: AppColor.secondary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Text(
                '추천',
                style: AppTextStyle.captionRegular.copyWith(
                  color: AppColor.deepBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
