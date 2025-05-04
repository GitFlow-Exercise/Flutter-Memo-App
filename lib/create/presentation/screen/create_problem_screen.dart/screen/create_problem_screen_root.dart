// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mongo_ai/create/presentation/screen/create_problem_screen.dart/controller/create_problem_action.dart';
// import 'package:mongo_ai/create/presentation/screen/create_problem_screen.dart/controller/create_problem_view_model.dart';
// import 'package:mongo_ai/create/presentation/screen/create_problem_screen.dart/screen/create_problem_screen.dart';
// import 'package:mongo_ai/home/presentation/controller/home_action.dart';

// import '../controller/home_event.dart';
// import 'home_screen.dart';
// import '../controller/home_view_model.dart';

// class CreateProblemScreenRoot extends ConsumerStatefulWidget {
//   final String cleanText;
//   const CreateProblemScreenRoot(this.cleanText, {super.key});

//   @override
//   ConsumerState<CreateProblemScreenRoot> createState() =>
//       _CreateProblemScreenRootState();
// }

// class _CreateProblemScreenRootState
//     extends ConsumerState<CreateProblemScreenRoot> {
//   StreamSubscription? _subscription;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final viewModel = ref.watch(createProblemViewModelProvider.notifier);

//       _subscription = viewModel.eventStream.listen(_handleEvent);

//       _handleAction(CreateProblemAction.setCleanText());
//     });
//   }

//   // 1회성 이벤트 처리 메서드
//   void _handleEvent(HomeEvent event) {
//     switch (event) {
//       case ShowSnackBar(message: final message):
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(message)));
//     }
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(createProblemViewModelProvider);

//     return Scaffold(
//       body: CreateProblemScreen(state: state, onAction: _handleAction),
//     );
//   }

//   Future<void> _handleAction(CreateProblemAction action) async {
//     final viewModel = ref.watch(createProblemViewModelProvider.notifier);

//     switch (action) {
//       case ChangeType(type: final type):
//         viewModel.changeProblemType(type);
//       case CreateProblem():
//         // TODO: Handle this case.
//         throw UnimplementedError();
//       case SetCleanText():
//         // TODO: Handle this case.
//         throw UnimplementedError();
//     }
//   }
// }
