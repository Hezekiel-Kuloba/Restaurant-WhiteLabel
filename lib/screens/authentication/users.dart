import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/utilis/users.dart';
import 'dart:convert';
import '../../models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import './register.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  List<User> users = [];
  final userService = UserServices();

  Future<void> _getUsers() async {
    users = await userService.getUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  void _showUpdateUserDialog(
      BuildContext context,
      String userId,
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String token) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

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
                  // initialValue: username,
                  controller: firstNameController,
                  decoration: InputDecoration(
                      labelText: 'Current First Name: $firstName'),
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                      labelText: 'Current Last Name: $lastName'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration:
                      InputDecoration(labelText: 'Current Email: $email'),
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration:
                      InputDecoration(labelText: 'Current Phone: $phoneNumber'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final String firstName = firstNameController.text;
                final String email = emailController.text;
                final String lastName = lastNameController.text;
                final String phoneNumber = phoneNumberController.text;

                final userService = UserServices();
                await userService
                    .updateUser(
                        userId, firstName, lastName, email, phoneNumber, token)
                    .then((_) {
                  _getUsers();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User updated successfully!')),
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

  void _confirmDeleteUser(BuildContext context, String userId, String token) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete user'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () async {
                await userService.deleteUser(userId, token).then((_) {
                  // Refresh the user list
                  _getUsers();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('user deleted successfully!')),
                  );
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Error 2: $e',
                    ),
                    duration: const Duration(seconds: 10),
                  ));
                });
              },
              child: const Text('Delete'),
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
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    String? role = authState.role;
    String? token = authState.token;
    bool? active = authState.active;

    print(role);
    print(active);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          actions: role == 'admin'
      ? [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Register(),
                ),
              );
            },
          ),
        ]
      : null,
        ),
        body: role == 'admin'
            ? ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text('${user.firstName}, ${user.lastName}'),
                    subtitle: Text(
                        '${user.email} - Phone number: ${user.phoneNumber}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showUpdateUserDialog(
                              context,
                              '${user.id}',
                              '${user.firstName}',
                              '${user.lastName}',
                              '${user.email}',
                              '${user.phoneNumber}',
                              token!),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _confirmDeleteUser(context, '${user.id}', token!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            : ListTile(
                title: Text('${authState.firstName}, ${authState.lastName}'),
                subtitle: Text(
                    '${authState.email} - Phone number: ${authState.phoneNumber}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showUpdateUserDialog(
                          context,
                          '${authState.id}',
                          '${authState.firstName}',
                          '${authState.lastName}',
                          '${authState.email}',
                          '${authState.phoneNumber}',
                          token!),
                    ),
                    // Additional icons or actions can be added here if needed
                  ],
                ),
              ));
  }
}
