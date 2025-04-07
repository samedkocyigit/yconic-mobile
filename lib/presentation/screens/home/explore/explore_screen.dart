import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/user/all_providers.dart';
import 'package:yconic/presentation/screens/home/explore/search_bar_with_dropdown.dart';
import 'package:yconic/presentation/screens/home/explore/suggestion_card.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsers = ref.watch(allUsersProvider);
    final currentUserId = ref.watch(authNotifierProvider).user?.Id;

    // 🔍 Public kullanıcıları filtrele (kendisi hariç)
    final publicUsers =
        allUsers.where((user) => user.id != currentUserId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Yconic Explore"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SearchBarWithDropdown(
            allUsers: publicUsers,
            onUserSelected: (user) {
              Navigator.pushNamed(
                context,
                '/user-profile',
                arguments: user.id,
              );
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kart yan yana
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: publicUsers.length,
              itemBuilder: (context, index) {
                return SuggestionCard(user: publicUsers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
