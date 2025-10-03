class LoginBody {
  final String password;
  final String phoneNumber;

  LoginBody({
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "Password": password,
      "PhoneNumber": phoneNumber,
    };
  }
}
