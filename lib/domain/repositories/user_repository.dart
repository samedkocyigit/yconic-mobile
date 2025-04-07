import 'package:yconic/domain/entities/public_user_profile.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<void> register(String email, String username, String password);
  Future<User> getUserById(String id);
  Future<void> sendFollowRequest(String requesterId, String targetUserId);
  Future<void> acceptFollowRequest(String targetUserId, String requesterId);
  Future<void> declineFollowRequest(String targetUserId, String requesterId);
  Future<void> followUser(String followerId, String followedId);
  Future<void> unfollowUser(String followerId, String followedId);
  Future<List<SimpleUser>> getAllUsers();
  Future<PublicUserProfile> getPublicUserProfile(String userId);
}
