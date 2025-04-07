import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/presentation/providers/app_providers.dart';
import 'package:yconic/presentation/providers/user/all_users_notifier.dart';

final allUsersProvider =
    StateNotifierProvider<AllUsersNotifier, List<SimpleUser>>((ref) {
  final usecase = ref.watch(getAllUsersUsecaseProvider);
  return AllUsersNotifier(usecase);
});
