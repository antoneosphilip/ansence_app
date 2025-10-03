
abstract class EndPoint{
  static const String apiBaseUrl = "http://madrasa.runasp.net/";

  static String getStudentAbsence(int id) {
    return "students/class/$id";
  }

  static String updateStudentAbsence(int id) {
    return "absences/$id";
  }
  static String getStudentMissing(int id) {
    return "absences/class/$id";
  }
  static const String signup = "servant/register";
  static const String signIn = "servant/login";

  static const String getAllAbsence = "students";

  static const String sendNotification = "https://fcm.googleapis.com/v1/projects/absence-app-633e1/messages:send";

}





