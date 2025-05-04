import 'dart:async';

import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/home/presentation/controller/home_event.dart';
import 'package:mongo_ai/home/presentation/controller/home_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  final _eventController = StreamController<HomeEvent>.broadcast();

  Stream<HomeEvent> get eventStream => _eventController.stream;

  @override
  HomeState build() {
    ref.onDispose(() {
      _eventController.close();
    });

    return const HomeState();
  }

  Future<void> loadHomeInfo() async {
    state = state.copyWith(homeData: const AsyncValue.loading());

    final useCase = ref.read(getHomeInfoUseCaseProvider);
    final result = await useCase.getHomeInfo();

    switch (result) {
      case Success(data: final homeData):
        state = state.copyWith(homeData: AsyncValue.data(homeData));
      case Error(error: final error):
        state = state.copyWith(
          homeData: AsyncValue.error(
            error,
            error.stackTrace ?? StackTrace.empty,
          ),
        );
    }

    if (state.homeData is AsyncError) {
      final error = (state.homeData as AsyncError).error;
      emitEvent(HomeEvent.showSnackBar('정보를 불러오는데 실패했습니다: $error'));
    }
  }

  Future<void> refreshHomeInfo() async {
    await loadHomeInfo();
  }

  void emitEvent(HomeEvent event) {
    _eventController.add(event);
  }
}
