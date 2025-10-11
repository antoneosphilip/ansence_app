import 'package:dio/dio.dart';
import 'api_error_model.dart';

class ErrorHandler implements Exception {
  final ApiErrorModel apiErrorModel;

  ErrorHandler._(this.apiErrorModel);

  factory ErrorHandler.handle(dynamic error) {
    // ✅ لو الخطأ من Dio (يعني جا من السيرفر أو من الاتصال)
    if (error is DioException) {
      final response = error.response;

      if (response != null) {
        final code = response.statusCode ?? 0;
        final data = response.data;
        print("dataaa ${data}");
        // ✅ لو السيرفر رجّع JSON فيه "message"
        if (data is Map<String, dynamic> && data['message'] != null) {
          return ErrorHandler._(
            ApiErrorModel(
              code: code,
              message: data['message'].toString(),
            ),
          );
        }

        // ✅ لو السيرفر رجّع نص عادي
        if (data is String) {
          print("this errorr ");

          return ErrorHandler._(
            ApiErrorModel(
              code: code,
              message: data,
            ),
          );
        }

        // fallback لو مفيش message واضحة
        return ErrorHandler._(
          ApiErrorModel(
            code: code,
            message: response.statusMessage ?? "حدث خطأ ما، برجاء المحاولة مرة أخرى",
          ),
        );
      }

      // ✅ لو مفيش response أصلاً (انقطاع إنترنت أو غيره)
      return ErrorHandler._(
        ApiErrorModel(
          code: 0,
          message: "تعذر الاتصال بالخادم. تحقق من اتصال الإنترنت.",
        ),
      );
    }

    // ✅ أي خطأ تاني غير Dio
    return ErrorHandler._(
      ApiErrorModel(
        code: 0,
        message: "حدث خطأ غير متوقع، برجاء المحاولة لاحقًا.",
      ),
    );
  }
}
