import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/usecases/userUsecases/login_usecase.dart';
import 'package:yconic/presentation/providers/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUsecase loginUsecase;

  AuthNotifier({required this.loginUsecase}) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await loginUsecase.execute(email, password);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() {
    state = AuthState();
  }
}
