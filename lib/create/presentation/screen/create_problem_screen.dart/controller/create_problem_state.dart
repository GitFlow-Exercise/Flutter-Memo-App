import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/home/domain/model/home.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(AsyncValue.loading()) AsyncValue<Home> homeData,
  }) = _HomeState;
}
