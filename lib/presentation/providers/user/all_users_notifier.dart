import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/domain/usecases/userUsecases/get_all_users_usecase.dart';

class AllUsersNotifier extends StateNotifier<List<SimpleUser>> {
  final GetAllUsersUsecase getAllUsersUsecase;

  AllUsersNotifier(this.getAllUsersUsecase) : super([]);

  Future<void> fetchAllUsers() async {
    try {
      final users = await getAllUsersUsecase.execute();
      state = users;
    } catch (e) {
      print("Fetch all users failed: $e");
    }
  }

  List<SimpleUser> search(String query, String? currentUserId) {
    return state
        .where((u) =>
            u.id != currentUserId &&
            u.username.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
