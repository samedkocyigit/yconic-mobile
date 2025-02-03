import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final String? token;
  final UserData? user;
  final bool? isAuthenticated;

  AuthState({this.token, this.user, this.isAuthenticated = false});

  AuthState copyWith({
    String? token,
    UserData? user,
    bool? isAuthenticated,
  }) {
    return AuthState(
      token: token ?? this.token,
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String name;
  final String surname;
  final int role;
  final int? age;
  final double? weight;
  final double? height;
  final String? phoneNumeber;
  final String userPersonaId;
  final String userGarderobeId;
  final Garderobe garderobe;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.role,
    this.age,
    this.weight,
    this.height,
    this.phoneNumeber,
    required this.userPersonaId,
    required this.userGarderobeId,
    required this.garderobe,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      role: json['role'],
      age: json['age'],
      weight: json['weight'],
      height: json['height'],
      phoneNumeber: json['phoneNumeber'],
      userPersonaId: json['userPersonaId'],
      userGarderobeId: json['userGarderobeId'],
      garderobe: Garderobe.fromJson(json['garderobe']),
    );
  }
}

class Garderobe {
  final String id;
  final String name;
  final String userId;
  final List<ClothesCategory> clothesCategory;

  Garderobe({
    required this.id,
    required this.name,
    required this.userId,
    required this.clothesCategory,
  });

  factory Garderobe.fromJson(Map<String, dynamic> json) {
    return Garderobe(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      clothesCategory: (json['clothesCategory'] as List)
          .map((e) => ClothesCategory.fromJson(e))
          .toList(),
    );
  }
}

class ClothesCategory {
  final String id;
  final String name;
  final String description;
  final String garderobeId;
  final List<Clothe> clothes;

  ClothesCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.garderobeId,
    required this.clothes,
  });

  factory ClothesCategory.fromJson(Map<String, dynamic> json) {
    return ClothesCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      garderobeId: json['garderobeId'],
      clothes:
          (json['clothes'] as List).map((e) => Clothe.fromJson(e)).toList(),
    );
  }
}

class Clothe {
  final String id;
  final String brand;
  final String name;
  final String? description;
  final String? mainPhoto;
  final String categoryId;
  final List<Photo> photos;

  Clothe({
    required this.id,
    required this.brand,
    required this.name,
    this.description,
    this.mainPhoto,
    required this.categoryId,
    required this.photos,
  });

  factory Clothe.fromJson(Map<String, dynamic> json) {
    return Clothe(
      id: json['id'],
      brand: json['brand'],
      name: json['name'],
      description: json['description'],
      mainPhoto: json['mainPhoto'],
      categoryId: json['categoryId'],
      photos: (json['photos'] as List).map((e) => Photo.fromJson(e)).toList(),
    );
  }
}

class Photo {
  final String id;
  final String url;
  final String clotheId;

  Photo({
    required this.id,
    required this.url,
    required this.clotheId,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      url: json['url'],
      clotheId: json['clotheId'],
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  void saveAuthData(String token, Map<String, dynamic> userData) {
    state = state.copyWith(
      token: token,
      user: UserData.fromJson(userData),
      isAuthenticated: true,
    );
  }

  void clearAuthData() {
    state = AuthState(isAuthenticated: false);
  }
}

// Provider for the AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
