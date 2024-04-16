
import 'package:dio/dio.dart';

abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(message: "Connection TimeOut");
      case DioExceptionType.sendTimeout:
        return ServerFailure(message: "Send TimeOut");
      case DioExceptionType.receiveTimeout:
        return ServerFailure(message: "Receive TimeOut");

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response!.statusCode!, dioError.response!);
      case DioExceptionType.cancel:
        return ServerFailure(message: "Request Canceled");

      case DioExceptionType.unknown:
        if (dioError.message!.contains("SocketException")) {
          return ServerFailure(message: "No Internet Connection");
        } else {
          return ServerFailure(message:  dioError.response!.data['message']);
        }

      default:
        return ServerFailure(message: dioError.response!.data['message']);
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(message:response.data['message']);
    } else if (statusCode == 404) {
      // 404 not found
      return ServerFailure(message: "Your Request Not Found Try Again Later");
    } else if (statusCode == 409) {
      // 409 conflict
      return ServerFailure(message: "Conflict Occurred");
    } else if (statusCode == 500) {
      // 500 internal server error
      return ServerFailure(message: "Internal Server Error , Try Again Later");
    } else {
      return ServerFailure(message: response.data['message']);
    }
  }
}

class FailureLocal extends Failure {
  FailureLocal({required super.message});
}
