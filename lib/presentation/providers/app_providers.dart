import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/data/repositories/user_repository_impl.dart';
import 'package:yconic/domain/repositories/user_repository.dart';
import 'package:yconic/domain/usecases/userUsecases/login_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/register_usecase.dart';
import 'package:yconic/presentation/providers/token_provider.dart';

const String baseUrl = 'http://10.0.2.2:5000/api';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final tokenService = ref.read(tokenServiceProvider);
  return UserRepositoryImpl(baseUrl: baseUrl, tokenService: tokenService);
});

final loginUseCaseProvider = Provider<LoginUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return LoginUsecase(repository);
});

final registerUseCaseProvider = Provider<RegisterUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return RegisterUsecase(repository);
});
