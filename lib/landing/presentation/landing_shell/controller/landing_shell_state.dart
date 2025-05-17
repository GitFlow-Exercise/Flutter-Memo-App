import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/landing/domain/enum/landing_header_menu_type.dart';

part 'landing_shell_state.freezed.dart';

@freezed
abstract class LandingShellState with _$LandingShellState {
  const factory LandingShellState({
    @Default(LandingHeaderMenuType.home) LandingHeaderMenuType selectLandingHeaderMenu,
  }) = _LandingShellState;
}

