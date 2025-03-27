import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/suggestion.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';

final suggestionProvider = Provider<List<Suggestion>>((ref) {
  final user = ref.watch(userProvider);
  return user?.Suggestions ?? [];
});
