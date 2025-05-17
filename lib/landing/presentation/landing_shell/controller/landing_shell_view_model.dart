import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/landing/domain/enum/landing_header_menu_type.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'landing_shell_view_model.g.dart';

@riverpod
class LandingShellViewModel extends _$LandingShellViewModel {
  @override
  LandingShellState build() {
    final authRepository = ref.watch(authRepositoryProvider);

    return LandingShellState(isAuthenticated: authRepository.isAuthenticated);
  }

  void setNavigationItem(LandingHeaderMenuType item) {
    state = state.copyWith(selectLandingHeaderMenu: item);
  }
}
