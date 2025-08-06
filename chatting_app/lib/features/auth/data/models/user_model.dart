import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
  });
  //product model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id ,
      name: user.name,
      email: user.email,
      password: user.password,
    );
  }
  //factory constructor
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '', // Add only if password is returned (usually it's not)
    );
  }
  //to json
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }

  UserModel fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
    );
  }
  Map<String, dynamic> toLoginJson() {
    return {'email': email, 'password': password};
  }
  Map<String, dynamic> toRegisterJson() {
    return {'name': name, 'email': email, 'password': password};
  }
}
