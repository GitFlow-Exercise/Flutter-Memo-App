import 'dart:async';

import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_event.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_otp_view_model.g.dart';

@riverpod
class CheckOtpViewModel extends _$CheckOtpViewModel {
  final _eventController = StreamController<CheckOtpEvent>();
  Stream<CheckOtpEvent> get eventStream => _eventController.stream;

  @override
  CheckOtpState build() {
    ref.onDispose(() {
      _eventController.close();
    });

    return const CheckOtpState();
  }
}