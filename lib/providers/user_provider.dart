import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateProvider<AuthState>((ref) => AuthState());

class AuthState {
  String? token;
  String? message;
  String? id;
  String? firstName;
  String? email;
  String? lastName;
  String? phoneNumber;
  String? role;
  bool? active;

  AuthState({
    this.token,
    this.message,
    this.id,
    this.firstName,
    this.email,
    this.lastName,
    this.phoneNumber,
    this.role,
    this.active,
  });
}
