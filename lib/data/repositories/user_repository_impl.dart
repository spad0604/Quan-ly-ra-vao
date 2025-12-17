import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final DioClient _dioClient;
  
  UserRepositoryImpl(this._dioClient);
  
  @override
  Future<List<User>> getUsers() async {
    final response = await _dioClient.get<List<dynamic>>(
      path: ApiEndpoints.users,
    );
    
    return response.map((json) => UserModel.fromJson(json)).toList();
  }
  
  @override
  Future<User> getUserById(int id) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      path: ApiEndpoints.userById(id),
    );
    
    return UserModel.fromJson(response);
  }
  
  @override
  Future<User> createUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    
    final response = await _dioClient.post<Map<String, dynamic>>(
      path: ApiEndpoints.users,
      data: userModel.toJson(),
    );
    
    return UserModel.fromJson(response);
  }
  
  @override
  Future<User> updateUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    
    final response = await _dioClient.put<Map<String, dynamic>>(
      path: ApiEndpoints.userById(user.id),
      data: userModel.toJson(),
    );
    
    return UserModel.fromJson(response);
  }
  
  @override
  Future<void> deleteUser(int id) async {
    await _dioClient.delete(
      path: ApiEndpoints.userById(id),
    );
  }
}
