class RegisterResponse {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? password;
  String? confirmPassword;
  String? token;
  String? message;

  RegisterResponse(
      {this.firstName,
      this.email,
      this.lastName,
      this.phoneNumber,
      this.password,
      this.confirmPassword,
      this.token,
      this.message});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    email = json['email'];
    lastName = json['lastName '];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['email'] = email;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['token'] = token;
    data['message'] = message;
    return data;
  }
}
