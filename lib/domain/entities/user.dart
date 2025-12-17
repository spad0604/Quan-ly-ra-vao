import 'entity.dart';

/// Example entity - User
class User extends Entity {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.avatar == avatar;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        avatar.hashCode;
  }
  
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, avatar: $avatar)';
  }
}
