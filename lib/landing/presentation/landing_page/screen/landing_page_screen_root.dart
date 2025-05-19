import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/landing/domain/enum/landing_header_menu_type.dart';
import 'package:mongo_ai/landing/presentation/landing_page/screen/landing_page_screen.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_view_model.dart';

class LandingPageScreenRoot extends ConsumerStatefulWidget {
  const LandingPageScreenRoot({super.key});

  @override
  ConsumerState<LandingPageScreenRoot> createState() =>
      _LandingPageScreenRootState();
}

class _LandingPageScreenRootState extends ConsumerState<LandingPageScreenRoot> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final landingShellViewModel = ref.watch(
        landingShellViewModelProvider.notifier,
      );

      landingShellViewModel.setNavigationItem(
        LandingHeaderMenuType.home,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LandingPageScreen());
  }
}
