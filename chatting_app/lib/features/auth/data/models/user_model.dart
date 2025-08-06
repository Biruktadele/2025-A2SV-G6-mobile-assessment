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
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
    );
  }
  //factory constructor
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
  UserModel fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
    );
  }
}