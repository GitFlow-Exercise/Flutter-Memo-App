import 'package:flutter/material.dart';
import 'package:mongo_ai/core/event/key/event_key_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_key.g.dart';

@riverpod
class AppEventKey extends _$AppEventKey {
  @override
  EventKeyState build() {
    return EventKeyState(
      scaffoldKey: GlobalKey<ScaffoldMessengerState>(),
      navigateKey: GlobalKey<NavigatorState>(),
    );
  }
}
