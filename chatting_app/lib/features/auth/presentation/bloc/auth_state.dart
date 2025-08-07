part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthFailure extends AuthState {
  final Failure failure;
  const AuthFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}

final class UnAuthState extends AuthState {
  const UnAuthState();
}

final class TokenCheck extends AuthState {
  const TokenCheck();
}
final class TokenCheckSuccess extends AuthState {
  const TokenCheckSuccess();
}