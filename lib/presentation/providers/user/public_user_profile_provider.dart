import 'package:yconic/domain/entities/simple_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/public_user_profile.dart';
import 'package:yconic/presentation/providers/app_providers.dart';

final publicUserProfileProvider = StateNotifierProvider.family<
    PublicUserProfileNotifier,
    AsyncValue<PublicUserProfile>,
    String>((ref, userId) {
  final notifier = PublicUserProfileNotifier(ref, userId);
  notifier.load();
  return notifier;
});

class PublicUserProfileNotifier
    extends StateNotifier<AsyncValue<PublicUserProfile>> {
  final Ref ref;
  final String userId;

  PublicUserProfileNotifier(this.ref, this.userId)
      : super(const AsyncLoading());

  Future<void> load() async {
    try {
      final usecase = ref.read(getPublicUserProfileUsecaseProvider);
      final profile = await usecase.execute(userId);
      if (mounted) {
        state = AsyncData(profile);
      }
    } catch (e, st) {
      if (mounted) {
        state = AsyncError(e, st);
      }
    }
  }
}

extension PublicUserProfileNotifierX on PublicUserProfileNotifier {
  void addFollower(SimpleUser newFollower) {
    if (state is! AsyncData) return;
    final user = (state as AsyncData).value;

    final alreadyExists = user.followers.any((u) => u.id == newFollower.id);
    if (alreadyExists) return;

    final updated = user.copyWith(
      followerCount: user.followerCount + 1,
      followers: List<SimpleUser>.from([...user.followers, newFollower]),
    );

    state = AsyncData(updated);
  }

  void removeFollower(String followerId) {
    if (state is! AsyncData) return;
    final user = (state as AsyncData).value;

    final updatedFollowers =
        user.followers.where((u) => u.id != followerId).toList();

    final updated = user.copyWith(
      followerCount: (user.followerCount > 0) ? user.followerCount - 1 : 0,
      followers: updatedFollowers,
    );

    state = AsyncData(updated);
  }

  void addFollowing(SimpleUser newFollowing) {
    if (state is! AsyncData) return;
    final user = (state as AsyncData).value;

    final alreadyExists = user.following.any((u) => u.id == newFollowing.id);
    if (alreadyExists) return;

    final updated = user.copyWith(
      followingCount: user.followingCount + 1,
      following: [...user.following, newFollowing],
    );

    state = AsyncData(updated);
  }

  void removeFollowing(String followingId) {
    if (state is! AsyncData) return;
    final user = (state as AsyncData).value;

    final updatedList =
        user.following.where((u) => u.id != followingId).toList();

    final updated = user.copyWith(
      followingCount: (user.followingCount > 0) ? user.followingCount - 1 : 0,
      following: updatedList,
    );

    state = AsyncData(updated);
  }
}
