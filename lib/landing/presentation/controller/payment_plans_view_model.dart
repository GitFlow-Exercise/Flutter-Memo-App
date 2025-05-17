import 'dart:async';

import 'package:mongo_ai/landing/presentation/controller/payment_plans_event.dart';
import 'package:mongo_ai/landing/presentation/controller/payment_plans_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_plans_view_model.g.dart';

@riverpod
class PaymentPlansViewModel extends _$PaymentPlansViewModel {
  final _eventController = StreamController<PaymentPlansEvent>();
  Stream<PaymentPlansEvent> get eventStream => _eventController.stream;

  @override
  PaymentPlansState build() {
    ref.onDispose(() {
      _eventController.close();
    });

    return const PaymentPlansState();
  }
}