import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/data/repositories/clothe_category_repository_impl.dart';
import 'package:yconic/data/repositories/clothe_photo_repository_impl.dart';
import 'package:yconic/data/repositories/clothe_repository_impl.dart';
import 'package:yconic/data/repositories/garderobe_repository_impl.dart';
import 'package:yconic/data/repositories/user_repository_impl.dart';
import 'package:yconic/domain/repositories/clothe_category_repository.dart';
import 'package:yconic/domain/repositories/clothe_photo_repository.dart';
import 'package:yconic/domain/repositories/clothe_repository.dart';
import 'package:yconic/domain/repositories/garderobe_repository.dart';
import 'package:yconic/domain/repositories/user_repository.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/create_clothe_category_usecase.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/delete_clothe_category_with_id_usecase.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/get_clothe_category_by_id_usecase.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/update_clothe_category_usecase.dart';
import 'package:yconic/domain/usecases/clothePhotoUsecases/create_clothe_photo_usecase.dart';
import 'package:yconic/domain/usecases/clothePhotoUsecases/delete_clothe_photo_with_id_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/create_clothe_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/delete_clothe_with_id_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/get_clothe_by_id_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/update_clothe_usecase.dart';
import 'package:yconic/domain/usecases/garderobeUsecases/delete_garderobe_with_id_usecase.dart';
import 'package:yconic/domain/usecases/garderobeUsecases/get_garderobe_by_id_usecase.dart';
import 'package:yconic/domain/usecases/garderobeUsecases/update_garderobe_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/accept_follow_request_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/cancel_follow_request_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/change_password_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/change_privacy_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/change_profile_photo_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/decline_follow_request_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/follow_user_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/get_all_users_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/get_public_user_profile_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/get_user_by_id_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/login_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/register_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/remove_follower_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/send_follow_request_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/unfollow_user_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/update_user_account_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/update_user_personal_usecase.dart';
import 'package:yconic/presentation/providers/token_provider.dart';

const String baseUrl = 'http://10.0.2.2:5000/api';

/*--------------------------------------
               User-Auth
----------------------------------------*/

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final tokenService = ref.read(tokenServiceProvider);
  return UserRepositoryImpl(baseUrl: baseUrl, tokenService: tokenService);
});

final loginUseCaseProvider = Provider<LoginUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return LoginUsecase(repository);
});

final registerUseCaseProvider = Provider<RegisterUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return RegisterUsecase(repository);
});

final getUserByIdUseCaseProvider = Provider<GetUserByIdUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserByIdUsecase(repository);
});

final getPublicUserProfileUsecaseProvider =
    Provider<GetPublicUserProfileUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetPublicUserProfileUsecase(repository);
});

final getAllUsersUsecaseProvider = Provider<GetAllUsersUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetAllUsersUsecase(repository);
});

final changePrivacyUsecaseProvider = Provider<ChangePrivacyUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return ChangePrivacyUsecase(repository);
});

final changePasswordUsecaseProvider = Provider<ChangePasswordUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return ChangePasswordUsecase(repository);
});

final changeProfilePhotoUsecaseProvider =
    Provider<ChangeProfilePhotoUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return ChangeProfilePhotoUsecase(repository);
});

final updateUserAccountUsecaseProvider =
    Provider<UpdateUserAccountUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateUserAccountUsecase(repository);
});

final updateUserPersonalUsecaseProvider =
    Provider<UpdateUserPersonalUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateUserPersonalUsecase(repository);
});

/* -------------------------------------
              Follow
----------------------------------------*/
final sendFollowRequestUsecaseProvider = Provider((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return SendFollowRequestUsecase(repo);
});

final acceptFollowRequestUsecaseProvider = Provider((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return AcceptFollowRequestUsecase(repo);
});

final declineFollowRequestUsecaseProvider = Provider((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return DeclineFollowRequestUsecase(repo);
});

final cancelFollowRequestUsecaseProvider = Provider((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return CancelFollowRequestUsecase(repo);
});

final followUserUsecaseProvider = Provider((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return FollowUserUsecase(repo);
});

final unfollowUserUsecaseProvider = Provider((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UnfollowUserUsecase(repo);
});

final removeFollowerUsecaseProvider = Provider((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return RemoveFollowerUsecase(repo);
});
/*--------------------------------------
               Clothe Category
----------------------------------------*/

final clotheCategoryRepositoryProvider =
    Provider<ClotheCategoryRepository>((ref) {
  return ClotheCategoryRepositoryImpl(baseUrl: baseUrl);
});

final createClotheCategoryUseCaseProvider =
    Provider<CreateClotheCategoryUsecase>((ref) {
  final repository = ref.watch(clotheCategoryRepositoryProvider);
  return CreateClotheCategoryUsecase(repository);
});

final updateClotheCategoryUseCaseProvider =
    Provider<UpdateClotheCategoryUsecase>((ref) {
  final repository = ref.watch(clotheCategoryRepositoryProvider);
  return UpdateClotheCategoryUsecase(repository);
});

final deleteClotheCategoryWithIdUseCaseProvider =
    Provider<DeleteClotheCategoryWithIdUsecase>((ref) {
  final repository = ref.watch(clotheCategoryRepositoryProvider);
  return DeleteClotheCategoryWithIdUsecase(repository);
});

final getClotheCategoryByIdUseCaseProvider =
    Provider<GetClotheCategoryByIdUsecase>((ref) {
  final repository = ref.watch(clotheCategoryRepositoryProvider);
  return GetClotheCategoryByIdUsecase(repository);
});

/*--------------------------------------
               Garderobe
----------------------------------------*/

final garderobeRepositoryProvider = Provider<GarderobeRepository>((ref) {
  return GarderobeRepositoryImpl(baseUrl: baseUrl);
});

final updateGarderobeUseCaseProvider = Provider<UpdateGarderobeUsecase>((ref) {
  final repository = ref.watch(garderobeRepositoryProvider);
  return UpdateGarderobeUsecase(repository);
});

final deleteGarderobeWithIdUseCaseProvider =
    Provider<DeleteGarderobeWithIdUsecase>((ref) {
  final repository = ref.watch(garderobeRepositoryProvider);
  return DeleteGarderobeWithIdUsecase(repository);
});

final getGarderobeByIdUseCaseProvider =
    Provider<GetGarderobeByIdUsecase>((ref) {
  final repository = ref.watch(garderobeRepositoryProvider);
  return GetGarderobeByIdUsecase(repository);
});

/*--------------------------------------
                 Clothe
----------------------------------------*/

final clotheRepositoryProvider = Provider<ClotheRepository>((ref) {
  return ClotheRepositoryImpl(baseUrl: baseUrl);
});

final createClotheUseCaseProvider = Provider<CreateClotheUsecase>((ref) {
  final repository = ref.watch(clotheRepositoryProvider);
  return CreateClotheUsecase(repository);
});

final updateClotheUseCaseProvider = Provider<UpdateClotheUsecase>((ref) {
  final repository = ref.watch(clotheRepositoryProvider);
  return UpdateClotheUsecase(repository);
});

final deleteClotheWithIdUseCaseProvider =
    Provider<DeleteClotheWithIdUsecase>((ref) {
  final repository = ref.watch(clotheRepositoryProvider);
  return DeleteClotheWithIdUsecase(repository);
});

final getClotheByIdUseCaseProvider = Provider<GetClotheByIdUsecase>((ref) {
  final repository = ref.watch(clotheRepositoryProvider);
  return GetClotheByIdUsecase(repository);
});

/*--------------------------------------
                 Clothe-Photo
----------------------------------------*/

final clothePhotoRepositoryProvider = Provider<ClothePhotoRepository>((ref) {
  return ClothePhotoRepositoryImpl(baseUrl: baseUrl);
});

final createClothePhotoUseCaseProvider =
    Provider<CreateClothePhotoUsecase>((ref) {
  final repository = ref.watch(clothePhotoRepositoryProvider);
  return CreateClothePhotoUsecase(repository);
});

final deleteClothePhotoWithIdUseCaseProvider =
    Provider<DeleteClothePhotoWithIdUsecase>((ref) {
  final repository = ref.watch(clothePhotoRepositoryProvider);
  return DeleteClothePhotoWithIdUsecase(repository);
});
