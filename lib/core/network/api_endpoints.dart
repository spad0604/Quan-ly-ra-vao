class ApiEndpoints {
  ApiEndpoints._();
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  
  // Example endpoints
  static const String users = '/users';
  static String userById(int id) => '/users/$id';
  static const String posts = '/posts';
  static String postById(int id) => '/posts/$id';
  
  // Add your endpoints here
}
