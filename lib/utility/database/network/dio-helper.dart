import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../../core/route_manager/page_name.dart';
import '../local/cache_helper.dart';
import 'end_points.dart';

class DioHelper {
  static late Dio dio;

  /// 🧩 تهيئة Dio مرة واحدة
  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: EndPoint.apiBaseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 🛡️ إضافة التوكن بشكل ديناميكي في كل طلب
          final token = CacheHelper.getDataString(key: 'token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        onError: (error, handler) {
          final response = error.response;
          final data = response?.data;

          // 🧭 معالجة الـ Unauthorized بشكل آمن
          if (response?.statusCode == 401) {
            if (data is Map<String, dynamic> &&
                data['message'] == "You are not authenticated") {
              CacheHelper.clearData();
              Get.offAllNamed(PageName.login);
            }
          }

          // ⚠️ طباعة الخطأ بشكل آمن
          debugPrint('❌ Dio Error: ${error.message}');
          if (response != null) {
            debugPrint('📦 Response data: ${response.data}');
            debugPrint('📡 Status code: ${response.statusCode}');
          }
          return handler.next(error);
        },
      ),
    );

    // 🔍 إضافة Logger في النهاية
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  /// 🌐 GET
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(
        url,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      debugPrint("-------------Error Data----------------");
      debugPrint('error is => ${e.response?.data ?? e.message}');
      debugPrint("-------------Error Data----------------");
      rethrow;
    }
  }

  /// 🌐 POST
  static Future<Response> postData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      debugPrint("-------------Error Data----------------");
      debugPrint('error is => ${e.response?.data ?? e.message}');
      debugPrint("-------------Error Data----------------");
      rethrow;
    }
  }

  /// 🌐 PUT
  static Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      debugPrint("-------------Error Data----------------");
      debugPrint('error is => ${e.response?.data ?? e.message}');
      debugPrint("-------------Error Data----------------");
      rethrow;
    }
  }

  /// 🌐 DELETE
  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.delete(
        url,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      debugPrint("-------------Error Data----------------");
      debugPrint('error is => ${e.response?.data ?? e.message}');
      debugPrint("-------------Error Data----------------");
      rethrow;
    }
  }
}
