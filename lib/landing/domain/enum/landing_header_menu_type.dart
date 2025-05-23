enum LandingHeaderMenuType {
  home,
  feature,
  howToUse,
  paymentPlans,
  help,
}

extension LandingHeaderMenuTypeExtension on LandingHeaderMenuType {
  String get title {
    switch (this) {
      case LandingHeaderMenuType.home:
        return '홈';
      case LandingHeaderMenuType.feature:
        return '기능';
      case LandingHeaderMenuType.howToUse:
        return '사용 방법';
      case LandingHeaderMenuType.paymentPlans:
        return '요금제';
      case LandingHeaderMenuType.help:
        return '도움말';
    }
  }
}