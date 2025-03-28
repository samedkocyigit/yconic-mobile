import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/data/repositories/clotheCategory_repository_impl.dart';
import 'package:yconic/data/repositories/clothePhoto_repository_impl.dart';
import 'package:yconic/data/repositories/clothe_repository_impl.dart';
import 'package:yconic/data/repositories/garderobe_repository_impl.dart';
import 'package:yconic/data/repositories/user_repository_impl.dart';
import 'package:yconic/domain/repositories/clotheCategory_repository.dart';
import 'package:yconic/domain/repositories/clothePhoto_repository.dart';
import 'package:yconic/domain/repositories/clothe_repository.dart';
import 'package:yconic/domain/repositories/garderobe_repository.dart';
import 'package:yconic/domain/repositories/user_repository.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/createClotheCategory_usecase.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/deleteClotheCategoryWithId_usecase.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/getClotheCategoryById_usecase.dart';
import 'package:yconic/domain/usecases/clotheCategoryUsecases/updateClotheCategory_usecase.dart';
import 'package:yconic/domain/usecases/clothePhotoUsecases/createClothePhoto_usecase.dart';
import 'package:yconic/domain/usecases/clothePhotoUsecases/deleteClothePhotoWithId_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/createClothe_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/deleteClotheWithId_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/getClotheById_usecase.dart';
import 'package:yconic/domain/usecases/clotheUsecases/updateClothe_usecase.dart';
import 'package:yconic/domain/usecases/garderobeUsecases/deleteGarderobeWithId_usecase.dart';
import 'package:yconic/domain/usecases/garderobeUsecases/getGarderobeById_usecase.dart';
import 'package:yconic/domain/usecases/garderobeUsecases/updateGarderobe_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/getUserById_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/login_usecase.dart';
import 'package:yconic/domain/usecases/userUsecases/register_usecase.dart';
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
