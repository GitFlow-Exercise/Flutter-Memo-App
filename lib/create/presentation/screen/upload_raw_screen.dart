import 'package:flutter/material.dart';
import 'package:mongo_ai/create/presentation/controller/upload_raw_action.dart';
import 'package:mongo_ai/create/presentation/controller/upload_raw_state.dart';

class UploadRawScreen extends StatefulWidget {
  final UploadRawState state;
  final void Function(UploadRawAction action) onAction;

  const UploadRawScreen({super.key, required this.state, required this.onAction});

  @override
  State<UploadRawScreen> createState() => _UploadRawScreenState();
}

class _UploadRawScreenState extends State<UploadRawScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
