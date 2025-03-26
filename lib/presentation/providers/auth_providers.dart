import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/app_providers.dart';
import 'package:yconic/presentation/providers/auth_notifier.dart';
import 'package:yconic/presentation/providers/auth_state.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final registerUsecase = ref.watch(registerUseCaseProvider);
  return AuthNotifier(
      ref: ref, loginUsecase: loginUseCase, registerUsecase: registerUsecase);
});
