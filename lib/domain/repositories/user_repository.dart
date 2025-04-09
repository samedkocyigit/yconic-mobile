import 'package:yconic/data/dtos/user/change_password_dto.dart';
import 'package:yconic/data/dtos/user/change_profile_photo_dto.dart';
import 'package:yconic/data/dtos/user/update_user_account_dto.dart';
import 'package:yconic/data/dtos/user/update_user_personal_dto.dart';
import 'package:yconic/domain/entities/public_user_profile.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<void> register(String email, String username, String password);
  Future<User> getUserById(String id);
  Future<User> changePrivacy(String id);
  Future<User> updateUserAccount(String id, UpdateUserAccountDto dto);
  Future<User> updateUserPersonal(String id, UpdateUserPersonalDto dto);
  Future<void> changePassword(String id, ChangePasswordDto dto);
  Future<User> changeProfilePhoto(String id, ChangeProfilePhotoDto dto);
  Future<void> sendFollowRequest(String requesterId, String targetUserId);
  Future<void> acceptFollowRequest(String targetUserId, String requesterId);
  Future<void> declineFollowRequest(String targetUserId, String requesterId);
  Future<void> cancelFollowRequest(String requesterId, String targetUserId);
  Future<void> followUser(String followerId, String followedId);
  Future<void> unfollowUser(String followerId, String followedId);
  Future<void> removeFollower(String followerId, String followedId);
  Future<List<SimpleUser>> getAllUsers();
  Future<PublicUserProfile> getPublicUserProfile(String userId);
}
