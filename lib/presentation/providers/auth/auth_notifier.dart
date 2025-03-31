import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/usecases/userUsecases/getUserById_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/login_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/register_usecase.dart';
import 'package:yconic/presentation/providers/auth/auth_state.dart';
import 'package:yconic/presentation/providers/token_provider.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final GetUserByIdUsecase getUserByIdUsecase;

  AuthNotifier(
      {required this.ref,
      required this.loginUsecase,
      required this.registerUsecase,
      required this.getUserByIdUsecase})
      : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await loginUsecase.execute(email, password);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(
    String email,
    String username,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await registerUsecase.execute(email, username, password);
      state = state.copyWith(isLoading: false, user: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await ref.read(tokenServiceProvider).deleteToken();
    state = AuthState();
  }

  Future<void> getUser(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final fetchedUser = await getUserByIdUsecase.execute(id);
      state = state.copyWith(isLoading: false, user: fetchedUser);
    } catch (e) {
      print("🔥 getUser error: $e");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
