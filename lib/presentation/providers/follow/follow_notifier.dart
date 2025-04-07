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

  Future<void> acceptFollowRequest(
      String targetUserId, String requesterId) async {
    state = const AsyncLoading();
    try {
      final usecase = ref.read(acceptFollowRequestUsecaseProvider);
      await usecase.execute(targetUserId, requesterId);

      final authUser = ref.read(authNotifierProvider).user!;
      final requesterUser =
          ref.read(publicUserProfileProvider(requesterId)).valueOrNull;

      ref.read(authNotifierProvider.notifier).addFollower(
            SimpleUser(
              id: requesterId,
              isPrivate: requesterUser?.isPrivate ?? false,
              username: requesterUser?.username ?? '',
              profilePhoto: requesterUser?.profilePhoto,
            ),
          );

      ref.read(publicUserProfileProvider(requesterId).notifier).addFollowing(
            authUser.toSimpleUser(),
          );

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
      final targetUser =
          ref.read(publicUserProfileProvider(targetUserId)).valueOrNull;

      ref.read(authNotifierProvider.notifier).addFollowing(
            SimpleUser(
              id: targetUserId,
              isPrivate: targetUser?.isPrivate ?? false,
              username: targetUser?.username ?? '',
              profilePhoto: targetUser?.profilePhoto,
            ),
          );

      ref.read(publicUserProfileProvider(targetUserId).notifier).addFollower(
            currentUser.toSimpleUser(),
          );

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
}
