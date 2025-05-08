import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_action.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_event.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_view_model.dart';
import 'package:mongo_ai/create/presentation/create_template/screen/create_template_screen.dart';

class CreateTemplateScreenRoot extends ConsumerStatefulWidget {
  final CreateTemplateViewModel viewModel;

  const CreateTemplateScreenRoot({super.key, required this.viewModel});

  @override
  ConsumerState<CreateTemplateScreenRoot> createState() => _CreateTemplateScreenRootState();
}

class _CreateTemplateScreenRootState extends ConsumerState<CreateTemplateScreenRoot> {
  StreamSubscription? _subscription;

  CreateTemplateViewModel get viewModel => widget.viewModel;
  CreateTemplateState get state => viewModel.state;

  @override
  void initState() {
    super.initState();
    _subscription = viewModel.eventStream.listen(_handleEvent);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(CreateTemplateEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message))
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createTemplateViewModelProvider);

    return Scaffold(
      body: CreateTemplateScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(CreateTemplateAction action) {
    switch (action) {
      case OnTap():
        debugPrint('tapped onTap');
    }
  }
}