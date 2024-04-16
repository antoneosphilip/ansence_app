// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../constants.dart';
// import '../../../model/auth/get_post_model.dart';
// import '../../../view/components/component.dart';
// import '../local/cache_helper.dart';
// import 'dio-helper.dart';
// import 'end_points.dart';
//
// class DioExceptions implements Exception {
//   String? message;
//
//   LoginModel? loginModel;
//
//   DioExceptions.fromDioError(DioError dioError) {
//     switch (dioError.type) {
//       case DioErrorType.cancel:
//         message = "Request to API server was cancelled";
//         break;
//       case DioErrorType.connectTimeout:
//         message = "Connection timeout with API server";
//         break;
//       case DioErrorType.receiveTimeout:
//         message = "Receive timeout in connection with API server";
//         break;
//       case DioErrorType.response:
//         message = dioError.response?.data['message'];
//
//         // this comment is login
//         if (message == 'Unauthorized') {
//           DioHelper.postData(url: refresh, data: {
//             'refresh_token': userRefreshToken,
//           }).then((value) {
//             loginModel = LoginModel.fromJson(value.data);
//             CacheHelper.put(
//                 key: "accessToken", value: loginModel!.data!.accessToken);
//             CacheHelper.put(
//                 key: "refreshToken", value: loginModel!.data!.refreshToken);
//             userToken = CacheHelper.get(key: "accessToken");
//             userRefreshToken = CacheHelper.get(key: "refreshToken");
//           }).catchError((onError) async {
//           await CacheHelper.removeData(key: "accessToken");
//           print(CacheHelper.get(key: "accessToken") +  " dasdasdasdasdasd");
//
//             if (onError is DioError) {
//               final errorMessage =
//                   DioExceptions.fromDioError(onError).toString();
//               showToast(message: errorMessage, color:'#AA1E9C');
//             }
//           });
//         }
//
//         //     _handleError(
//         //   dioError.response?.statusCode,
//         //   dioError.response?.data,
//         // );
//         break;
//       case DioErrorType.sendTimeout:
//         message = "Send timeout in connection with API server";
//         break;
//       case DioErrorType.other:
//         if (dioError.message.contains("SocketException")) {
//           message = 'No Internet';
//           break;
//         }
//         message = "Unexpected error occurred";
//         break;
//       default:
//         message = "Something went wrong";
//         break;
//     }
//   }
//
//   String _handleError(int? statusCode, dynamic error) {
//     switch (statusCode) {
//       case 400:
//         return error['message'];
//       case 401:
//         return 'Unauthorized';
//       case 403:
//         return 'Forbidden';
//       case 404:
//         return error['message'];
//       case 500:
//         return 'Internal server error';
//       case 502:
//         return 'Bad gateway';
//       default:
//         return 'Oops something went wrong';
//     }
//   }
//
//   @override
//   String toString() => message ?? '';
// }
