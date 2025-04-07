import 'package:flutter/material.dart';
import 'package:yconic/domain/entities/simple_user.dart';

class SuggestionCard extends StatelessWidget {
  final SimpleUser user;

  const SuggestionCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🖼️ Placeholder image
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/default_suggestion.jpg'), // dummy image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 👤 Kullanıcı bilgisi
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: user.profilePhoto != null
                      ? NetworkImage(user.profilePhoto!)
                      : const AssetImage("assets/default_avatar.jpg")
                          as ImageProvider,
                  radius: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  user.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
