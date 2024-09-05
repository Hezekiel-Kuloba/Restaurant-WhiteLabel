import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/screens/authentication/login.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../utilis/users.dart';

class UserMeScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserMeScreen({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserMeScreenState();
}

class _UserMeScreenState extends ConsumerState<UserMeScreen> {
  User? user;
  final userService = UserServices();

  Future<void> _getUsers(String userId, String token) async {
    user = (await userService.getUserById(userId, token));
    setState(() {});
  }

  Future<void> _logout() async {
    await userService.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void _showUpdateUserDialog(
    BuildContext context,
    String userId,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String token,
  ) {
    final TextEditingController firstNameController =
        TextEditingController(text: firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: lastName);
    final TextEditingController emailController =
        TextEditingController(text: email);
    final TextEditingController phoneNumberController =
        TextEditingController(text: phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final String updatedFirstName = firstNameController.text;
                final String updatedLastName = lastNameController.text;
                final String updatedEmail = emailController.text;
                final String updatedPhoneNumber = phoneNumberController.text;

                await userService
                    .updateUser(userId, updatedFirstName, updatedLastName,
                        updatedEmail, updatedPhoneNumber, token)
                    .then((_) {
                  _getUsers(userId, token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User updated successfully!')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                }).catchError((e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                });
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    _getUsers(widget.userId, authState.token!);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align to the top
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_outline,
                size: 100.0,
                color: Colors.orange,
              ),
              const SizedBox(height: 20.0),
              Text(
                '${user!.firstName} ${user!.lastName}',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10.0),
              Divider(color: Colors.grey), // Line decoration
              const SizedBox(height: 10.0),
              Text(
                'Email: ${user!.email}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10.0),
              Text(
                'Phone Number: ${user!.phoneNumber}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20.0),
              Divider(color: Colors.grey), // Line decoration
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _showUpdateUserDialog(
                      context,
                      widget.userId,
                      '${user!.firstName}',
                      '${user!.lastName}',
                      '${user!.email}',
                      '${user!.phoneNumber}',
                      authState.token!,
                    ),
                    child: const Text('Edit Profile'),
                  ),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Log out'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
