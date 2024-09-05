import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/screens/authentication/users-me.dart';
import '../../providers/user_provider.dart';

class ProfileIcon extends ConsumerStatefulWidget {
  const ProfileIcon({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileIconState();
}

class _ProfileIconState extends ConsumerState<ProfileIcon> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    String? userId = authState.id;
    print(userId);
    return IconButton(
      icon: const Icon(Icons.person),
      onPressed: () {
        if (userId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserMeScreen(
                userId: userId, // Pass the userId here
              ),
            ),
          );
        } else {
          // Handle the case where userId is null, e.g., show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User ID is not available')),
          );
        }
      },
    );
  }
}
