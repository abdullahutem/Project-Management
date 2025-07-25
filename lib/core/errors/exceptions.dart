import 'package:cmp/core/errors/error_model.dart';
import 'package:dio/dio.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;

  ServerException({required this.errorModel});
}

// void handelDioException(DioException e) {
//   switch (e.type) {
//     case DioExceptionType.connectionTimeout:
//       ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.sendTimeout:
//       ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.receiveTimeout:
//       ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.badCertificate:
//       ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.cancel:
//       ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.connectionError:
//       ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.unknown:
//       ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
//     case DioExceptionType.badResponse:
//       switch (e.response?.statusCode) {
//         case 302: // Bad request
//           throw ServerException(
//             errorModel: ErrorModel.fromJson(e.response!.data),
//           );
//         case 400: // Bad request
//           throw ServerException(
//             errorModel: ErrorModel.fromJson(e.response!.data),
//           );
//         case 401: //unauthorized
//           throw ServerException(
//             errorModel: ErrorModel.fromJson(e.response!.data),
//           );
//         case 403: //forbidden
//           throw ServerException(
//             errorModel: ErrorModel.fromJson(e.response!.data),
//           );
//         case 404: //not found
//           throw ServerException(
//             errorModel: ErrorModel.fromJson(e.response!.data),
//           );
//         case 409: //cofficient
//           throw ServerException(
//             errorModel: ErrorModel.fromJson(e.response!.data),
//           );
//         case 422: //  Unprocessable Entity
//           throw ServerException(
//             errorModel: ErrorModel.fromJson(e.response!.data),
//           );
//         case 500: // Server exception
//           throw ServerException(
//             errorModel: ErrorModel.fromJson(e.response!.data),
//           );
//         case 504: // Server exception
//           throw ServerException(
//             errorModel: ErrorModel.fromJson(e.response!.data),
//           );
//       }
//   }
// }

// Ensure this function is called when a DioException occurs
void handelDioException(DioException e) {
  ErrorModel? errorModel; // Declare ErrorModel outside the switch

  // Attempt to parse the error model from the response data
  if (e.response != null && e.response!.data is Map<String, dynamic>) {
    try {
      errorModel = ErrorModel.fromJson(e.response!.data);
    } catch (parseError) {
      // Fallback if parsing fails (e.g., unexpected error JSON format)
      errorModel = ErrorModel(
        message: 'Failed to parse server error: $parseError',
      );
    }
  }

  // Fallback for cases where response data is not available or not a Map
  if (errorModel == null) {
    String errorMessage;
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'No internet connection or server unreachable.';
    } else if (e.response?.statusCode != null) {
      errorMessage = 'Server error: Status ${e.response!.statusCode}';
    } else {
      errorMessage = 'An unexpected network error occurred.';
    }
    errorModel = ErrorModel(message: errorMessage);
  }

  // Always throw a ServerException with the determined errorModel
  throw ServerException(errorModel: errorModel);
}
