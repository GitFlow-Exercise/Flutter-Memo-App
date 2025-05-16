import 'dart:async';

import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_event.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_profile_view_model.g.dart';

@riverpod
class MyProfileViewModel extends _$MyProfileViewModel {
  final _eventController = StreamController<MyProfileEvent>();

  Stream<MyProfileEvent> get eventStream => _eventController.stream;

  @override
  MyProfileState build() {
    ref.onDispose(() {
      _eventController.close();
    });

    return const MyProfileState();
  }
}
