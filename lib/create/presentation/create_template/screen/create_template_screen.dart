import 'package:flutter/material.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_action.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

class CreateTemplateScreen extends StatefulWidget {
  final CreateTemplateState state;
  final void Function(CreateTemplateAction action) onAction;

  const CreateTemplateScreen({super.key, required this.state, required this.onAction});

  @override
  State<CreateTemplateScreen> createState() => _CreateTemplateScreenState();
}

class _CreateTemplateScreenState extends State<CreateTemplateScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}