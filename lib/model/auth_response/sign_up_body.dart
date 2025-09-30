class RegisterBody {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final Map<String, int> servantClasses;

  RegisterBody({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.servantClasses,
  });

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Email": email,
      "Password": password,
      "ConfirmPassword": confirmPassword,
      "PhoneNumber": phoneNumber,
      "ServantClasses": servantClasses,
    };
  }
}
