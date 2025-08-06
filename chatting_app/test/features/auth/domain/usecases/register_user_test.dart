import 'package:chatting_app/core/error/failure.dart';

import 'package:chatting_app/features/auth/domain/entities/user.dart';
import 'package:chatting_app/features/auth/domain/repositories/user_repository.dart';
import 'package:chatting_app/features/auth/domain/usecases/register_user.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../sampledata/data.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late RegisterUserUsecase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = RegisterUserUsecase(mockUserRepository);
  });

  // Test user data
  final User tUser = const  User(
  name: 'Test User',
  email: 'test@example.com',
  password: 'password123',
);

  test('should register user when repository returns success', () async {
    // arrange
    when(
      () => mockUserRepository.registerUser(tUser),
    ).thenAnswer((_) async => Right(tUser));

    // act
    final result = await usecase(tUser);

    // assert
    expect(result, equals(Right(tUser)));
    verify(() => mockUserRepository.registerUser(tUser));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    final tFailure = const ServerFailure('Registration failed');
    when(
      () => mockUserRepository.registerUser(tUser),
    ).thenAnswer((_) async => Left(tFailure));

    // act
    final result = await usecase(tUser);

    // assert
    expect(result, equals(Left(tFailure)));
    verify(() => mockUserRepository.registerUser(tUser));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return ValidationFailure when user data is invalid', () async {
    // arrange
    final User invalidUser = const  User(
  name: 'Test User',
  email: 'test@example.com',
  password: 'password123',
);
    final tFailure = const ValidationFailure('Invalid user data');
    when(
      () => mockUserRepository.registerUser(invalidUser),
    ).thenAnswer((_) async => Left(tFailure));

    // act
    final result = await usecase(invalidUser);

    // assert
    expect(result, equals(Left(tFailure)));
    verify(() => mockUserRepository.registerUser(invalidUser));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
