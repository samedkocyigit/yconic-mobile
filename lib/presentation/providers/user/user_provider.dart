import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';

final userProvider = StateProvider<User?>((ref) {
  return ref.watch(authNotifierProvider).user;
});
