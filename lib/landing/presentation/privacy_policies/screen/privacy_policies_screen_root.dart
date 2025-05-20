import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/landing/presentation/privacy_policies/controller/privacy_policies_view_model.dart';
import 'package:mongo_ai/landing/presentation/privacy_policies/screen/privacy_policies_screen.dart';

class PrivacyPoliciesScreenRoot extends ConsumerStatefulWidget {
  const PrivacyPoliciesScreenRoot({super.key});

  @override
  ConsumerState<PrivacyPoliciesScreenRoot> createState() => _PrivacyPoliciesScreenRootState();
}

class _PrivacyPoliciesScreenRootState extends ConsumerState<PrivacyPoliciesScreenRoot> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(privacyPoliciesViewModelProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(privacyPoliciesViewModelProvider);

    return Scaffold(
      body: PrivacyPoliciesScreen(state: state),
    );
  }
}