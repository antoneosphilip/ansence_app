class SignInResponse {
  final String id;
  final String userName;
  final String phoneNumber;
  final String email;
  final String password;

  SignInResponse({
    required this.id,
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
    };
  }
}
