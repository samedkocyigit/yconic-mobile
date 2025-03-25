import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/app_providers.dart';
import 'package:yconic/presentation/providers/auth_notifier.dart';
import 'package:yconic/presentation/providers/auth_state.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  return AuthNotifier(loginUsecase: loginUseCase);
});
