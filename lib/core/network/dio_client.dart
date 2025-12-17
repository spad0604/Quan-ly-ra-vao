import 'package:dio/dio.dart';

import '../utils/app_constants.dart';
import 'network_exceptions.dart';

/// Dio client để xử lý tất cả các network requests
class DioClient {
  late final Dio _dio;
  
  // Singleton pattern
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _dio.interceptors.add(_createInterceptor());
  }
  
  /// Get Dio instance
  Dio get dio => _dio;
  
  /// Tạo interceptor để log và xử lý token
  InterceptorsWrapper _createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Thêm token vào header nếu có
        final token = await _getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        // Log request trong debug mode
        print('🚀 Request: ${options.method} ${options.path}');
        print('📦 Data: ${options.data}');
        print('🔑 Headers: ${options.headers}');
        
        return handler.next(options);
      },
      
      onResponse: (response, handler) {
        // Log response trong debug mode
        print('✅ Response: ${response.statusCode} ${response.requestOptions.path}');
        print('📦 Data: ${response.data}');
        
        return handler.next(response);
      },
      
      onError: (error, handler) async {
        // Log error trong debug mode
        print('❌ Error: ${error.response?.statusCode} ${error.requestOptions.path}');
        print('📦 Error Data: ${error.response?.data}');
        
        // Xử lý refresh token nếu 401
        if (error.response?.statusCode == 401) {
          // Có thể implement logic refresh token ở đây
          // final isRefreshed = await _refreshToken();
          // if (isRefreshed) {
          //   return handler.resolve(await _retry(error.requestOptions));
          // }
        }
        
        return handler.next(error);
      },
    );
  }
  
  /// Lấy access token từ storage
  Future<String?> _getAccessToken() async {
    // TODO: Implement lấy token từ SharedPreferences hoặc secure storage
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString(AppConstants.accessToken);
    return null;
  }
  
  /// GET request
  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
  
  /// POST request
  Future<T> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
  
  /// PUT request
  Future<T> put<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
  
  /// DELETE request
  Future<T> delete<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
  
  /// PATCH request
  Future<T> patch<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
