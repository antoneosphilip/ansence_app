
abstract class EndPoint{
  static const String apiBaseUrl = "http://madrasa.runasp.net/";

  static String getStudentAbsence(int id) {
    return "students/class/$id";
  }
  static String getCapacity='class/get-capacity';
  static String getClassesNumber="servant/get-classes";

  static String updateStudentAbsence(String id) {
    return "absences/$id";
  }
  static String checkMissingClasses='servant/check-eftikad-of-classes';
  static String getStudentMissing(int id) {
    return "absences/class/$id";
  }
  static const String signup = "servant/register";
  static const String signIn = "servant/login";

  static const String getAllAbsence = "students";

  static const String sendNotification = "https://fcm.googleapis.com/v1/projects/absence-app-633e1/messages:send";

  static const String sendEmail = "servant/send-email";

  static const String checkOtp = "servant/check-otp";

  static const String changePassword = "servant/change-password";


}





