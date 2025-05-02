import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_action.freezed.dart';

@freezed
sealed class HomeAction with _$HomeAction {
  const factory HomeAction.loadHomeInfo() = LoadHomeInfo;

  const factory HomeAction.refresh() = Refresh;

  const factory HomeAction.onTapDetail() = OnTapDetail;
}
