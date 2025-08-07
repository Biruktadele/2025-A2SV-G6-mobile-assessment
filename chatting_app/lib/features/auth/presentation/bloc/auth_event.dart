part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class LoginUser extends AuthEvent {
  final String email;
  final String password;
  const LoginUser(this.email,this.password);

  @override
  List<Object?> get props => [email,password];
}



final class RegisterUser extends AuthEvent {
  final String name;
  final String email;
  final String password;
    
  
  const RegisterUser(this.name ,this.email,this.password);

  @override
  List<Object?> get props => [name,email,password];
}

final class LogoutUser extends AuthEvent {
  const LogoutUser();

  @override
  List<Object?> get props => [];
}
final class Getuser extends AuthEvent {
  final String token;
  const Getuser(this.token);

  @override
  List<Object?> get props => [token];
}
final class CheckToken extends AuthEvent {
  const CheckToken();

  @override
  List<Object?> get props => [];
}