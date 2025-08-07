// test/auth/bloc/auth_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/auth/domain/entities/user.dart';
import 'package:chatting_app/features/auth/domain/repositories/user_repository.dart';
import 'package:chatting_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late AuthBloc authBloc;
  late MockUserRepository mockUserRepository;

  final tUser = const User(
    id: '1',
    name: 'John',
    email: 'john@example.com',
    password: 'password123',
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    authBloc = AuthBloc(mockUserRepository);
  });

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when LoginUser is successful',
      build: () {
        when(mockUserRepository.loginUser(any))
            .thenAnswer((_) async => Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginUser('john@example.com', 'password123')),
      expect: () => [
        const AuthLoading(),
        AuthSuccess(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when LoginUser fails',
      build: () {
        when(mockUserRepository.loginUser(any)).thenAnswer(
          (_) async => const Left(ServerFailure('Login failed')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginUser('john@example.com', 'wrongpass')),
      expect: () => [
        const AuthLoading(),
        const AuthFailure(ServerFailure('Login failed')),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when RegisterUser is successful',
      build: () {
        when(mockUserRepository.registerUser(any))
            .thenAnswer((_) async => Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterUser('John', 'john@example.com', 'password123')),
      expect: () => [
        const AuthLoading(),
        AuthSuccess(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when RegisterUser fails',
      build: () {
        when(mockUserRepository.registerUser(any))
            .thenAnswer((_) async => const Left(ServerFailure('Register failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterUser('John', 'john@example.com', 'badpass')),
      expect: () => [
        const AuthLoading(),
        const AuthFailure(ServerFailure('Register failed')),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when LogoutUser is called',
      build: () {
        when(mockUserRepository.logoutUser()).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LogoutUser()),
      expect: () => [
        const AuthLoading(),
        const AuthSuccess(User(id: '', name: '', email: '', password: '')),
      ],
    );
  });
}
