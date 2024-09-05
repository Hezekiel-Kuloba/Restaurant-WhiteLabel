class LoginResponse {
  String? token;
  String? status;
  String? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? role;
  bool? active;

  LoginResponse({
    this.token,
    this.status,
    this.id,
    this.firstName,
    this.email,
    this.lastName,
    this.phoneNumber,
    this.role,
    this.active,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    status = json['status'];
    id = json['_id']; // Added this line to map the id correctly
    firstName = json['firstName'];
    email = json['email'];
    lastName = json['lastName']; // Corrected typo here
    phoneNumber = json['phoneNumber'];
    role = json['role'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['status'] = status;
    data['id'] = id; // Added this line to map the id correctly
    data['firstName'] = firstName;
    data['email'] = email;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['role'] = role;
    data['active'] = active;
    return data;
  }
}
