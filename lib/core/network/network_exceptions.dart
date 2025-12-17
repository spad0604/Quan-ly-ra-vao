import 'package:dio/dio.dart';

/// Custom exception để xử lý các lỗi network
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  NetworkException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;

  factory NetworkException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Timeout: Vui lòng kiểm tra kết nối mạng',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        
        switch (statusCode) {
          case 400:
            return NetworkException(
              message: _extractMessage(data) ?? 'Yêu cầu không hợp lệ',
              statusCode: statusCode,
              data: data,
            );
          case 401:
            return NetworkException(
              message: 'Phiên đăng nhập đã hết hạn',
              statusCode: statusCode,
              data: data,
            );
          case 403:
            return NetworkException(
              message: 'Bạn không có quyền truy cập',
              statusCode: statusCode,
              data: data,
            );
          case 404:
            return NetworkException(
              message: 'Không tìm thấy dữ liệu',
              statusCode: statusCode,
              data: data,
            );
          case 500:
          case 502:
          case 503:
            return NetworkException(
              message: 'Lỗi máy chủ, vui lòng thử lại sau',
              statusCode: statusCode,
              data: data,
            );
          default:
            return NetworkException(
              message: _extractMessage(data) ?? 'Có lỗi xảy ra',
              statusCode: statusCode,
              data: data,
            );
        }

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Yêu cầu đã bị hủy',
        );

      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return NetworkException(
            message: 'Không có kết nối mạng',
          );
        }
        return NetworkException(
          message: 'Có lỗi xảy ra: ${error.message}',
        );

      default:
        return NetworkException(
          message: 'Có lỗi xảy ra',
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;
    
    if (data is Map) {
      // Thử các key phổ biến
      final message = data['message'] ?? 
                     data['error'] ?? 
                     data['msg'] ?? 
                     data['detail'];
      return message?.toString();
    }
    
    if (data is String) {
      return data;
    }
    
    return null;
  }
}
