import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../core/route_manager/page_name.dart';
import '../local/cache_helper.dart';
import 'end_points.dart';


//Dio Helper That's Connect and Talk to API.
class DioHelper {
  static late Dio dio;

  //Here The Initialize of Dio and Start Connect to API Using baseUrl.

  static init() {
    dio = Dio(
      BaseOptions(
        //Here the URL of API.
        baseUrl: EndPoint.baseUrl,
        connectTimeout: const Duration(minutes: 2),
        receiveDataWhenStatusError: true,
        //Here we Put The Headers Needed in The API.
        headers: {
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,PATCH,OPTIONS"
          //'lang':'en'
        },
      ),
    )..interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options , handle) async {
          options.headers['Authorization'] = 'Bearer ${CacheHelper.getDataString(key: 'token')}';
          // options.headers['Authorization'] = 'Bearer 579|hKYuHaor7ARdObih2o6dzX4N34fWLb97fqtpxMjW';
          return handle.next(options);
        },
        onError: (error, handle)
        {
          if( error.response!.data['message'] ==  "You are not authenticated" && error.response!.statusCode == 401)
          {
            CacheHelper.clearData();
            Get.offAllNamed(PageName.login);
          }
          return handle.next(error);
        },
      ),
      PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90),
    ]);
  }

  //This Function to call API and get Some Data based on url(End Points) and Headers needed in API to get the Specific Data.
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    String? token,
    Options? options,
  }) async {
    // dio.options.headers = {
    //   'x-auth-token': token ?? '',
    //   'Content-Type': 'application/json',
    // };
    // return await dio.get(
    //   url,
    // );
    debugPrint("-------------End Point----------------");
    debugPrint(url);
    debugPrint("-------------End Point----------------");
    debugPrint("-------------Request Data----------------");
    debugPrint('data is $queryParameters');
    debugPrint("-------------Request Data----------------");
    debugPrint("-------------Request Data----------------");
    debugPrint('data is $token');
    debugPrint("-------------Request Data----------------");

    try {
      dio.options.headers = {
        'Authorization': 'Bearer ${token ?? ''}',
      };
      final Response response = await dio.get(
        url,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      debugPrint("-------------Response Data----------------");
      debugPrint('response is => ${response.data}');
      debugPrint("-------------Response Data----------------");
      return response;
    } on DioError catch (e) {
      debugPrint("-------------Error Data----------------");
      debugPrint('error is => ${e.response!.data}');
      debugPrint("-------------Error Data----------------");
      rethrow;
    }
  }

  //This Function that's Used To Post Data to API based on URL(End Points) and Headers.
  static Future<Response> postData({
    required String url,
    required var data,
    //bool files = false,
    String? token,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String? ContentType,
  }) async {
    dio.options.headers = {
      'Authorization': 'Bearer ${token ?? ''}',
    };
    debugPrint("-------------End Point----------------");
    debugPrint(url);
    debugPrint("-------------End Point----------------");

    debugPrint("-------------Request Data----------------");
    debugPrint('data is $data');
    debugPrint("-------------Request Data----------------");
    debugPrint("-------------Request Data----------------");
    debugPrint('data is $token');
    debugPrint("-------------Request Data----------------");
    try {
      final Response response = await dio.post(
        url,
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      debugPrint("-------------Response Data----------------");
      debugPrint('response is => ${response.data}');
      debugPrint("-------------Response Data----------------");
      return response;
    } on DioError catch (e) {
      debugPrint("-------------Error Data------------------");
      debugPrint('error is ${e.response!.data}');
      debugPrint("-------------Error Data------------------");
      rethrow;
    }
  }

  // dio.options.headers = {
  //   'Authorization': 'Bearer ${token ?? ''}',
  // };
  // return await dio.post(url, data: data).then((value) {
  //   return value;
  // }).catchError((onError) {
  //   if (onError is DioError) {
  //     print('vaerrrr--------->');
  //     print(onError.response!.statusCode);
  //     showToast(
  //         message: onError.response!.data['message'].toString(),
  //         color: Colors.red);
  //   }
  // });

  //This Function That's Used to Update Some Date based on URL(End Points) and Send what's you need to Update as Map.
  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    String? token,
    //bool files = false,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      dio.options.headers = {
        'Authorization': 'Bearer ${token ?? ''}',
      };
      final Response response = await dio.put(
        url,
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
    // dio.options.headers = {
    //   'x-auth-token': token ?? '',
    //   //'Content-Type': 'application/json',
    // };
    // return await dio.put(
    //   url,
    //   data: data,
    // );
  }

  //This Function That's Used to Update Some Date based on URL(End Points) and Send what's you need to Update as Map.
  static Future<Response> patchData({
    required String url,
    required Map<String, dynamic> data,
    required String token,
    bool files = false,
  }) async {
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      // 'Authorization': token ,
      'Content-Type': 'application/json',
    };
    return await dio.patch(
      url,
      data: data,
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    String? token,
    //String lang = 'en',
  }) async {
    try {
      dio.options.headers = {
        'Authorization': 'Bearer $token',
        // 'Authorization': token ,
        //'Content-Type': 'application/json',
      };
      final Response response = await dio.delete(
        url,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
    // dio.options.headers = {
    //   'x-auth-token': userToken,
    //   'Content-Type': 'application/json',
    // };
    // return await dio.delete(url, data: data ?? '').catchError((error) {
    //   print("DIO ERROR $error");
    // });
  }



  static Future<Response> downloadData({
    required String token,
    required String savePath,
    required String url,
  }) async {

    dio.options.headers = {
      'Authorization': 'Bearer $token',
      // 'Authorization': token ,
      'Content-Type': 'application/json',
    };
    return await dio.download(url, savePath);
  }
}
