import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/follow/follow_notifier.dart';

final followNotifierProvider =
    StateNotifierProvider<FollowNotifier, AsyncValue<void>>((ref) {
  return FollowNotifier(ref);
});
