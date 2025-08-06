import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/auth/domain/entities/user.dart';
import 'package:chatting_app/features/auth/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;

  // Test user data
  final User tUser = const User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  group('registerUser', () {
    test('should return User when registration is successful', () async {
      // arrange
      when(() => mockUserRepository.registerUser(tUser)).thenAnswer((_) async => Right(tUser)); 

      // act
      final result = await mockUserRepository.registerUser(tUser);

      // assert
      expect(result, equals(Right(tUser)));
      verify(() => mockUserRepository.registerUser(tUser)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return Failure when registration fails', () async {
      // arrange
      final tFailure = const ServerFailure('Registration failed');
      when(
        () => mockUserRepository.registerUser(tUser),
      ).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await mockUserRepository.registerUser(tUser);

      // assert
      expect(result, equals(Left(tFailure)));
      verify(() => mockUserRepository.registerUser(tUser)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    });
  });

  group('loginUser', () {
    test('should return User when login is successful', () async {
      // arrange
      when(() => mockUserRepository.loginUser(tUser)).thenAnswer((_) async => Right(tUser));

      // act
      final result = await mockUserRepository.loginUser(tUser);

      // assert
      expect(result, equals(Right(tUser)));
      verify(() => mockUserRepository.loginUser(tUser)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return Failure when login fails', () async {
      // arrange
      final tFailure = const ServerFailure('Login failed');
      when(() => mockUserRepository.loginUser(tUser)).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await mockUserRepository.loginUser(tUser);

      // assert
      expect(result, equals(Left(tFailure)));
      verify(() => mockUserRepository.loginUser(tUser)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    });
  });

  group('logoutUser', () {
    test('should complete successfully when logout is successful', () async {
      // arrange
      when(
        () => mockUserRepository.logoutUser(),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await mockUserRepository.logoutUser();

      // assert
      expect(result, equals(const Right(null)));
      verify(() => mockUserRepository.logoutUser()).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return Failure when logout fails', () async {
      // arrange
      final tFailure = const ServerFailure('Logout failed');
      when(
        () => mockUserRepository.logoutUser(),
      ).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await mockUserRepository.logoutUser();

      // assert
      expect(result, equals(Left(tFailure)));
      verify(() => mockUserRepository.logoutUser()).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    });
  });
}
