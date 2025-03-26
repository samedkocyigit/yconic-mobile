import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/usecases/userUsecases/login_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/register_usecase.dart';
import 'package:yconic/presentation/providers/auth_state.dart';
import 'package:yconic/presentation/providers/token_provider.dart';
import 'package:yconic/presentation/providers/user_provider.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;

  AuthNotifier(
      {required this.ref,
      required this.loginUsecase,
      required this.registerUsecase})
      : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await loginUsecase.execute(email, password);
      ref.read(userProvider.notifier).state = user;
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(
    String email,
    String password,
    String confirmPassword,
    String name,
    String surname,
    DateTime birthday,
    String phoneNumber,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await registerUsecase.execute(email, password, confirmPassword, name,
          surname, birthday, phoneNumber);
      state = state.copyWith(isLoading: false, user: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await ref.read(tokenServiceProvider).deleteToken();
    ref.read(userProvider.notifier).state = null;
    state = AuthState();
  }
}
