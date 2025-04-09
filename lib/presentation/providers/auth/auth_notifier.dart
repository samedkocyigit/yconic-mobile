import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/data/dtos/user/change_password_dto.dart';
import 'package:yconic/data/dtos/user/change_profile_photo_dto.dart';
import 'package:yconic/data/dtos/user/update_user_account_dto.dart';
import 'package:yconic/data/dtos/user/update_user_personal_dto.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/domain/usecases/userUsecases/get_user_by_id_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/login_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/register_usecase.dart';
import 'package:yconic/presentation/providers/app_providers.dart';
import 'package:yconic/presentation/providers/auth/auth_state.dart';
import 'package:yconic/presentation/providers/token_provider.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final GetUserByIdUsecase getUserByIdUsecase;

  AuthNotifier(
      {required this.ref,
      required this.loginUsecase,
      required this.registerUsecase,
      required this.getUserByIdUsecase})
      : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await loginUsecase.execute(email, password);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(
    String email,
    String username,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await registerUsecase.execute(email, username, password);
      state = state.copyWith(isLoading: false, user: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await ref.read(tokenServiceProvider).deleteToken();
    state = AuthState();
  }

  Future<void> getUser(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final fetchedUser = await getUserByIdUsecase.execute(id);
      state = state.copyWith(isLoading: false, user: fetchedUser);
    } catch (e) {
      print("🔥 getUser error: $e");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

extension ExtendedAuthNotifier on AuthNotifier {
  Future<void> updateUserPersonal(UpdateUserPersonalDto dto) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final updated = await ref
          .read(updateUserPersonalUsecaseProvider)
          .execute(currentUser.Id, dto);
      state = state.copyWith(isLoading: false, user: updated);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> changePrivacy() async {
    final currentUser = state.user;
    if (currentUser == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final updated =
          await ref.read(changePrivacyUsecaseProvider).execute(currentUser.Id);
      state = state.copyWith(isLoading: false, user: updated);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> updateUserAccount(UpdateUserAccountDto dto) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final updated = await ref
          .read(updateUserAccountUsecaseProvider)
          .execute(currentUser.Id, dto);
      state = state.copyWith(isLoading: false, user: updated);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> changeProfilePhoto(ChangeProfilePhotoDto dto) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final updated = await ref
          .read(changeProfilePhotoUsecaseProvider)
          .execute(currentUser.Id, dto);
      state = state.copyWith(isLoading: false, user: updated);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> changePassword(ChangePasswordDto dto) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    state = state.copyWith(isLoading: true);
    try {
      await ref
          .read(changePasswordUsecaseProvider)
          .execute(currentUser.Id, dto);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

extension AuthNotifierExtensions on AuthNotifier {
  void addFollowing(SimpleUser userToAdd) {
    final currentUser = state.user;
    if (currentUser == null) return;

    final alreadyExists =
        currentUser.Following?.any((u) => u.id == userToAdd.id) ?? false;
    if (alreadyExists) return;

    final updatedUser = currentUser.copyWith(
      Following: [...?currentUser.Following, userToAdd],
      FollowingCount: (currentUser.FollowingCount ?? 0) + 1,
    );

    state = state.copyWith(user: updatedUser);
  }

  void addSentFollowRequest(SimpleUser targetUser) {
    final currentUser = state.user;
    if (currentUser == null) return;

    final alreadySent =
        currentUser.SentFollowRequest?.any((u) => u.id == targetUser.id) ??
            false;
    if (alreadySent) return;

    final updatedUser = currentUser.copyWith(
      SentFollowRequest: [...?currentUser.SentFollowRequest, targetUser],
    );

    state = state.copyWith(user: updatedUser);
  }

  void addFollower(SimpleUser newFollower) {
    final currentUser = state.user;
    if (currentUser == null) return;

    final alreadyExists =
        currentUser.Followers?.any((f) => f.id == newFollower.id) ?? false;
    if (alreadyExists) return;

    final updated = currentUser.copyWith(
      Followers: [...?currentUser.Followers, newFollower],
      FollowerCount: (currentUser.FollowerCount ?? 0) + 1,
    );

    state = state.copyWith(user: updated);
  }

  void removeFollower(String followerId) {
    final currentUser = state.user;
    if (currentUser == null) return;

    final updatedFollowers =
        currentUser.Followers?.where((u) => u.id != followerId).toList();
    final updated = currentUser.copyWith(
      Followers: updatedFollowers,
      FollowerCount: (currentUser.FollowerCount ?? 1) - 1,
    );

    state = state.copyWith(user: updated);
  }

  void removeFollowing(String followingId) {
    final currentUser = state.user;
    if (currentUser == null) return;

    final updatedFollowing =
        currentUser.Following?.where((u) => u.id != followingId).toList();
    final updated = currentUser.copyWith(
      Following: updatedFollowing,
      FollowingCount: (currentUser.FollowingCount ?? 1) - 1,
    );

    state = state.copyWith(user: updated);
  }

  void removeSentFollowRequest(String userId) {
    final currentUser = state.user;
    if (currentUser == null) return;

    final updated = currentUser.copyWith(
      SentFollowRequest:
          currentUser.SentFollowRequest?.where((u) => u.id != userId).toList(),
    );

    state = state.copyWith(user: updated);
  }

  void removeReceivedFollowRequest(String userId) {
    final currentUser = state.user;
    if (currentUser == null) return;

    final updated = currentUser.copyWith(
      RecievedFollowRequest:
          currentUser.RecievedFollowRequest?.where((u) => u.id != userId)
              .toList(),
    );

    state = state.copyWith(user: updated);
  }
}
