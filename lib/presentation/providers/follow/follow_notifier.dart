import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/domain/entities/user.dart';
import 'package:yconic/presentation/providers/app_providers.dart';
import 'package:yconic/presentation/providers/auth/auth_notifier.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/user/public_user_profile_provider.dart';

class FollowNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  FollowNotifier(this.ref) : super(const AsyncData(null));

  Future<void> sendFollowRequest(
      String requesterId, String targetUserId) async {
    state = const AsyncLoading();
    try {
      final usecase = ref.read(sendFollowRequestUsecaseProvider);
      await usecase.execute(requesterId, targetUserId);

      final targetUser =
          ref.read(publicUserProfileProvider(targetUserId)).valueOrNull;
      final currentUser = ref.read(authNotifierProvider).user!;

      ref.read(authNotifierProvider.notifier).addSentFollowRequest(
            SimpleUser(
              id: targetUserId,
              isPrivate: targetUser?.isPrivate ?? false,
              username: targetUser?.username ?? '',
              profilePhoto: targetUser?.profilePhoto,
            ),
          );

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> cancelFollowRequest(
      String currentUserId, String targetUserId) async {
    state = const AsyncLoading();
    try {
      final usecase = ref.read(cancelFollowRequestUsecaseProvider);
      await usecase.execute(currentUserId, targetUserId);

      ref
          .read(authNotifierProvider.notifier)
          .removeSentFollowRequest(targetUserId);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> acceptFollowRequest(
      String targetUserId, String requesterId) async {
    state = const AsyncLoading();
    try {
      final usecase = ref.read(acceptFollowRequestUsecaseProvider);
      await usecase.execute(targetUserId, requesterId);

      final authUser = ref.read(authNotifierProvider).user!;

      // Get the requester public profile.
      final requesterProfileNotifier =
          ref.read(publicUserProfileProvider(requesterId).notifier);
      var requesterUser =
          ref.read(publicUserProfileProvider(requesterId)).valueOrNull;
      // If not already loaded, force a fetch.
      if (requesterUser == null) {
        await requesterProfileNotifier.load();
        requesterUser =
            ref.read(publicUserProfileProvider(requesterId)).valueOrNull;
      }

      // Safely create a SimpleUser with the full information.
      final simpleRequester = SimpleUser(
        id: requesterId,
        isPrivate: requesterUser?.isPrivate ?? false,
        username: requesterUser?.username ?? '',
        profilePhoto: requesterUser?.profilePhoto,
      );

      // Add the new follower to the auth user.
      ref.read(authNotifierProvider.notifier).addFollower(simpleRequester);
      // Update the requester’s profile to add the current user as following.
      ref
          .read(publicUserProfileProvider(requesterId).notifier)
          .addFollowing(authUser.toSimpleUser());
      // Remove the received follow request so it disappears from your list.
      ref
          .read(authNotifierProvider.notifier)
          .removeReceivedFollowRequest(requesterId);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> declineFollowRequest(
      String targetUserId, String requesterId) async {
    state = const AsyncLoading();
    try {
      final usecase = ref.read(declineFollowRequestUsecaseProvider);
      await usecase.execute(targetUserId, requesterId);

      ref
          .read(authNotifierProvider.notifier)
          .removeReceivedFollowRequest(requesterId);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    state = const AsyncLoading();
    try {
      final usecase = ref.read(followUserUsecaseProvider);
      await usecase.execute(currentUserId, targetUserId);

      final currentUser = ref.read(authNotifierProvider).user!;
      final targetUserProfileNotifier =
          ref.read(publicUserProfileProvider(targetUserId).notifier);

      // 1) Attempt to read user from the provider
      var targetUser =
          ref.read(publicUserProfileProvider(targetUserId)).valueOrNull;

      // 2) If null, force a fetch
      if (targetUser == null) {
        await targetUserProfileNotifier.load();
        targetUser =
            ref.read(publicUserProfileProvider(targetUserId)).valueOrNull;
      }

      // 3) Create a SimpleUser with the real username
      final simpleTargetUser = SimpleUser(
        id: targetUserId,
        isPrivate: targetUser?.isPrivate ?? false,
        username: targetUser?.username ?? '',
        profilePhoto: targetUser?.profilePhoto,
      );

      // 4) Add the user to the current user’s 'following' list
      ref.read(authNotifierProvider.notifier).addFollowing(simpleTargetUser);

      // 5) Add current user to the target's 'followers' list
      ref
          .read(publicUserProfileProvider(targetUserId).notifier)
          .addFollower(currentUser.toSimpleUser());

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    state = const AsyncLoading();
    try {
      final usecase = ref.read(unfollowUserUsecaseProvider);
      await usecase.execute(currentUserId, targetUserId);

      ref.read(authNotifierProvider.notifier).removeFollowing(targetUserId);
      ref
          .read(publicUserProfileProvider(targetUserId).notifier)
          .removeFollower(currentUserId);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> removeFollower(String targetUserId, String currentUserId) async {
    state = const AsyncLoading();
    try {
      final usecase = ref.read(removeFollowerUsecaseProvider);
      await usecase.execute(targetUserId, currentUserId);

      ref.read(authNotifierProvider.notifier).removeFollower(targetUserId);
      ref
          .read(publicUserProfileProvider(targetUserId).notifier)
          .removeFollower(currentUserId);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
