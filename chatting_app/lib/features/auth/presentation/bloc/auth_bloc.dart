import 'package:bloc/bloc.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;


  AuthBloc(this.userRepository) : super(const AuthInitial()) {
    // on<AuthEvent>(_onAuthEvent);
    // on<CheckToken>(_onCheckToken);
    // on<Getuser>(_onGetuser);
    on<LogoutUser>(_onLogoutUser);
    on<LoginUser>(_onLoginUser);
    on<RegisterUser>(_onRegisterUser);
  }

  Future<void> _onLoginUser(LoginUser event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
  final user = User(
              email: event.email,
              password: event.password,
            );
    
    final userModel = UserModel.fromEntity(user);
    final result = await userRepository.loginUser(userModel);
    
    result.fold(
        (failure) => emit(AuthFailure(failure)),
        (user) => emit(AuthSuccess(user)),
      );
    } catch (e) {
      emit(AuthFailure(ServerFailure(e.toString())));
    }
  }

  Future<void> _onRegisterUser(RegisterUser event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = User(
            name: event.name,
            email: event.email,
            password: event.password,
          );
    
    final result = await userRepository.registerUser(user);
    
    result.fold(
        (failure) => emit(AuthFailure(failure)),
        (user) => emit(AuthSuccess(user)),
      );
    } catch (e) {
      emit(AuthFailure(ServerFailure(e.toString())));
    }
  }

  Future<void> _onLogoutUser(LogoutUser event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await userRepository.logoutUser();
      emit(const AuthSuccess(User(id: '', name: '', email: '', password: '')));
    } catch (e) {
      emit(AuthFailure(ServerFailure(e.toString())));
    }
  }
}
