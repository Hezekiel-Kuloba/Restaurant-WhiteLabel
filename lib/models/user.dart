class User {
  String? firstName;
  String? id;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? password;
  String? confirmPassword;
  String? role;
  bool? active;

  User(
      {this.firstName,
      this.email,
      this.id,
      this.lastName,
      this.phoneNumber,
      this.role,
      this.active,
      this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    email = json['email'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    role = json['role'];
    active = json['active'] == true ||
            json['active'] == 'true' ||
            json['active'] == null
        ? false
        : json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['firstName'] = firstName;
    data['email'] = email;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['role'] = role;
    data['active'] = active;
    return data;
  }
}
