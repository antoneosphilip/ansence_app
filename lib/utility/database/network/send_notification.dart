// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
// import 'package:either_dart/either.dart';
//
// import '../../../core/networking/api_error_handler.dart';
// import 'end_points.dart';
// abstract class SendNotification{
//  static Future<String> getAccessToken() async {
//     final Map<String, dynamic> serviceAccountJson = <String, String>{
//       "type": "service_account",
//       "project_id": "absence-app-633e1",
//       "private_key_id": "d2d3280286cfb290e3bfa88f13a912e455c6e400",
//       "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDHsVL41atYbSnx\nOrKHbDdjfPxF5eLfJ4THbZ0cmBAClZ8oFAy2ud+7ER4NQF4ObPJsKd1GLlJcVyRD\naOtI01Si/5XybmMuflleNFkasN/Wj41CHViC023r9iwWGk5hPIawixPftfxYd/zA\ndSaJovd5jnwutd5ILo+76mjDQuCWT0JfpvBGtdi8D7axtwAftN/wwdkRddon39KL\n/oD928WdMmw6uHQMigdX34hIdHbf92eNVjFo/Y8pzjlKsV17TSamxnT/2r+86kDs\n9l8J+U0h8v/03Z+kXxKg8ePnpTS6SPABaVY9eVn/FwpFD5MCTJGYUrepj/G1EL/i\ncnvbIpx3AgMBAAECggEATii+k/x1gze+6dcSl2SozTzXNLiEstkx5CioDNALvCc5\n0yL90usvgXVysLcX2UeVHvbHz7dDrzbAT84aATgN8XpeAzRnh4QWkIOmuIawJbes\nD0uTICmG5YtFuCT1tqNNCH52+eGt8iaMe/ueaNKrUB2Px2yRoujugxt9g6eCZfHQ\nDFMa7ypkMyXckxRcP6ZHvHifsZBV8NpU3/Rmhxw3p+bKLgy0c3IHKGcXk7h3CmVZ\ndsZHhO+/4E84A7a98gytKtyHzOvxDDLj8pNCl6AS2vW49R99TJ2nVelmfgOv+cCX\nn8T32FucSQ99Fhghp+Dc/0Qrdn1/GsG6/LB4zHjt0QKBgQD3nXvHAlZf12BXwF9p\n4A+H0EetQfvQbQPnCgD4ftXdJXDqwXr74Aug6LBDgAEa6q9sGxbc3175bKVsofRq\nJdB7wvGGjaZJafcjDGrpoYsnJRgVVyyB3bVvzSU7I/zlOReRl0q3mFJyNg/salKb\nMKeoBiLfGZegiOrRLDQaMR1miQKBgQDOdGl26OHHa+Ui8+15mwdOI6W2dl0ro/ZC\nnIPH6iwTCrLdNmJruiMEIsY89eEz6Mg89FxZdzGIttnafgQAnAzZH1sv9gjt4mob\nsmJ39sevaeHVYTziNrCfY3dD68klL0AbDhtj1sndRP47m/2xDMBRrB+hhoJduZP8\nXEnNyg8q/wKBgQD16jqmr6SWtLDjFZPs83CZIno9EN4E5m/Mwfuqz1SYt/mHvDXm\n9mC2IsIDl5oBYHht9g1juJd7QbKcy8+QqBOBBl+WkRFHseyWq1t2wlAPxWBAuX3j\nUAxEh8nlDV25TVUh685xvd6LvTNdSU7W/6BSWB3D0ofrEG+c47ivFn4reQKBgDpy\nGD0ydmBXOhnoBi1r5uiHDO2Xmo61LwzydBgPQgTt/W7Ea55lpm4QTiCJ1wQz/SPM\nZaxqItq6MPg6vnVRuA1rZAwy0ZpOg41ttZSShzswdV9L1MmRg/TLWsMep+Xf93zx\nRG3CK4l5c6N6aJpLqtI0MQwwIQ3ZcHx7v+UDM8IPAoGBAM/hhKShzzvN8eTOL2H/\nmQWShsZklSbmE7lkwR/lUIBFt2P0KJcT7W4ET85+Etyn6MVrXQEzmxiluzYnYIxl\nskpZGaQyMDWSotCZcYsFaPXwfADU0Uh47yws4KcPnYUAYyGuBhroNgvqCbdbP4dQ\n409MrSLu2HDxnuwyi1mgVzIZ\n-----END PRIVATE KEY-----\n",
//       "client_email": "firebase-adminsdk-jcch7@absence-app-633e1.iam.gserviceaccount.com",
//       "client_id": "117323631294260373207",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-jcch7%40absence-app-633e1.iam.gserviceaccount.com",
//       "universe_domain": "googleapis.com"
//     };
//     List<String> scopes = [
//       "https://www.googleapis.com/auth/userinfo.email",
//       "https://www.googleapis.com/auth/firebase.database",
//       "https://www.googleapis.com/auth/firebase.messaging"
//     ];
//     http.Client client = await auth.clientViaServiceAccount(
//       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//       scopes,
//     );
//     auth.AccessCredentials credentials =
//     await auth.obtainAccessCredentialsViaServiceAccount(
//         auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//         scopes,
//         client);
//     client.close();
//     return credentials.accessToken.data;
//   }
//
//  static Future<Either<ErrorHandler, dynamic>> sendNotification({required tokenBody,required title,required bodyMessage}) async {
//     final String accessToken = await getAccessToken();
//
//     var body = {
//       "message": {
//         "token": tokenBody,
//         "notification": {
//           "title": title,
//           "body": bodyMessage
//         },
//         "android": {
//           "notification": {"sound": "notification"}
//         }
//       }
//     };
//     try {
//       final http.Response response = await http.post(
//         Uri.parse(EndPoint.sendNotification),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken'
//         },
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode == 200) {
//         print('Notification sent successfully');
//       } else {
//         print('Failed to send notification${response.body}');
//       }
//
//       return Right(response);
//     }
//     catch (e) {
//       print("sucess${e}");
//
//       return Left(ErrorHandler.handle(e));
//     }
//   }
// }