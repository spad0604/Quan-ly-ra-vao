import '../entities/user.dart';

/// User repository interface
/// Data layer sẽ implement interface này
abstract class UserRepository {
  /// Get list of users
  Future<List<User>> getUsers();
  
  /// Get user by id
  Future<User> getUserById(int id);
  
  /// Create new user
  Future<User> createUser(User user);
  
  /// Update user
  Future<User> updateUser(User user);
  
  /// Delete user
  Future<void> deleteUser(int id);
}
