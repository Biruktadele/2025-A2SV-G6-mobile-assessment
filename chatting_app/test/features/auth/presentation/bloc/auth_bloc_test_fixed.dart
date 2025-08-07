import 'package:bloc_test/bloc_test.dart';
import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/auth/domain/entities/user.dart';
import 'package:chatting_app/features/auth/domain/repositories/user_repository.dart';
import 'package:chatting_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Create a mock repository class
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  // Test data
  const tUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );

  late MockUserRepository mockUserRepository;
  late AuthBloc authBloc;

  setUp(() {
    mockUserRepository = MockUserRepository();
    authBloc = AuthBloc(mockUserRepository);
  });

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      // assert
      expect(authBloc.state, isA<AuthInitial>());
    });

    group('Login', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthSuccess] when login is successful',
        build: () {
          when(mockUserRepository.loginUser(any)).thenAnswer((_) async => Right(tUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LoginUser('test@example.com', 'password123')),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ],
        verify: (_) {
          verify(mockUserRepository.loginUser(any)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthFailure] when login fails',
        build: () {
          when(mockUserRepository.loginUser(any))
              .thenAnswer((_) async => Left(ServerFailure('Login failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LoginUser('wrong@example.com', 'wrongpass')),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>(),
        ],
      );
    });

    group('Register', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthSuccess] when registration is successful',
        build: () {
          when(mockUserRepository.registerUser(any))
              .thenAnswer((_) async => Right(tUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const RegisterUser('Test User', 'test@example.com', 'password123'),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ],
        verify: (_) {
          verify(mockUserRepository.registerUser(any)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthFailure] when registration fails',
        build: () {
          when(mockUserRepository.registerUser(any))
              .thenAnswer((_) async => Left(ServerFailure('Email already in use')));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const RegisterUser('Test User', 'existing@example.com', 'password123'),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>(),
        ],
      );
    });

    group('Logout', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, UnAuthState] when logout is successful',
        build: () {
          when(mockUserRepository.logoutUser())
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LogoutUser()),
        expect: () => [
          isA<AuthLoading>(),
          isA<UnAuthState>(),
        ],
        verify: (_) {
          verify(mockUserRepository.logoutUser()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthFailure] when logout fails',
        build: () {
          when(mockUserRepository.logoutUser())
              .thenAnswer((_) async => Left(ServerFailure('Logout failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LogoutUser()),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>(),
        ],
      );
    });
  });
}
