import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).clearAuthData();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: const Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 24),
            ProfileInfoTile(
              title: 'Ad',
              value: userData?.name ?? '',
            ),
            ProfileInfoTile(
              title: 'Soyad',
              value: userData?.surname ?? '',
            ),
            ProfileInfoTile(
              title: 'E-posta',
              value: userData?.email ?? '',
            ),
            if (userData?.phoneNumeber != null)
              ProfileInfoTile(
                title: 'Telefon',
                value: userData!.phoneNumeber!,
              ),
            if (userData?.age != null)
              ProfileInfoTile(
                title: 'Yaş',
                value: userData!.age.toString(),
              ),
            if (userData?.weight != null)
              ProfileInfoTile(
                title: 'Kilo',
                value: '${userData!.weight} kg',
              ),
            if (userData?.height != null)
              ProfileInfoTile(
                title: 'Boy',
                value: '${userData!.height} cm',
              ),
            ProfileInfoTile(
              title: 'Gardırop',
              value: userData?.garderobe.name ?? '',
            ),
            ProfileInfoTile(
              title: 'Kategori Sayısı',
              value: '${userData?.garderobe.clothesCategory.length ?? 0}',
            ),
            ProfileInfoTile(
              title: 'Toplam Kıyafet',
              value: '${_calculateTotalClothes(userData)}',
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTotalClothes(UserData? userData) {
    if (userData == null) return 0;
    return userData.garderobe.clothesCategory.fold(
      0,
      (sum, category) => sum + category.clothes.length,
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoTile({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
