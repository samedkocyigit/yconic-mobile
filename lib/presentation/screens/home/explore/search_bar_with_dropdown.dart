import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/simple_user.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';

class SearchBarWithDropdown extends ConsumerStatefulWidget {
  final List<SimpleUser> allUsers;
  final void Function(SimpleUser user) onUserSelected;

  const SearchBarWithDropdown({
    super.key,
    required this.allUsers,
    required this.onUserSelected,
  });

  @override
  _SearchBarWithDropdownState createState() => _SearchBarWithDropdownState();
}

class _SearchBarWithDropdownState extends ConsumerState<SearchBarWithDropdown> {
  final TextEditingController _controller = TextEditingController();
  List<SimpleUser> filteredUsers = [];

  void _onChanged(String query) {
    final lowercaseQuery = query.toLowerCase();
    setState(() {
      filteredUsers = widget.allUsers
          .where((u) =>
              u.username.toLowerCase().contains(lowercaseQuery) &&
              u.id != ref.read(authNotifierProvider).user?.Id)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 Arama Kutusu
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: "Search username...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        // 📄 Dropdown sonucu
        if (_controller.text.isNotEmpty && filteredUsers.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profilePhoto != null
                        ? NetworkImage(user.profilePhoto!)
                        : const AssetImage("assets/default_avatar.jpg")
                            as ImageProvider,
                  ),
                  title: Text(user.username),
                  onTap: () {
                    widget.onUserSelected(user);
                    _controller.clear();
                    setState(() {
                      filteredUsers = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
