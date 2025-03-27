import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/app_providers.dart';
import 'package:yconic/presentation/providers/auth/auth_notifier.dart';
import 'package:yconic/presentation/providers/auth/auth_state.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final registerUseCase = ref.watch(registerUseCaseProvider);
  final getUserByIdUseCase = ref.watch(getUserByIdUseCaseProvider);
  return AuthNotifier(
      ref: ref,
      loginUsecase: loginUseCase,
      registerUsecase: registerUseCase,
      getUserByIdUsecase: getUserByIdUseCase);
});
