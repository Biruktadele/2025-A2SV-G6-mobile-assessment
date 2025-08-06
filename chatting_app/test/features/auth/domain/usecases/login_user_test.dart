import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/auth/domain/entities/user.dart';
import 'package:chatting_app/features/auth/domain/repositories/user_repository.dart';
import 'package:chatting_app/features/auth/domain/usecases/login_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main(){
  late LoginUserUsecase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = LoginUserUsecase(mockUserRepository);
  });

  // Test user data
  final User tUser = const User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );

  test('should login user when repository returns success', () async {
    // arrange
    when(() => mockUserRepository.loginUser(tUser)).thenAnswer((_) async => Right(tUser));

    // act
    final result = await usecase(tUser);

    // assert
    expect(result, equals(Right(tUser)));
    verify(() => mockUserRepository.loginUser(tUser));
    verifyNoMoreInteractions(mockUserRepository);
  });
test('should return ValidationFailure when user data is invalid', () async {
    // arrange
    final User invalidUser = const  User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
);
    final tFailure = const ValidationFailure('Invalid user data');
    when(() => mockUserRepository.loginUser(invalidUser)).thenAnswer((_) async => Left(tFailure));

    // act
    final result = await usecase(invalidUser);

    // assert
    expect(result, equals(Left(tFailure)));
    verify(() => mockUserRepository.loginUser(invalidUser));
    verifyNoMoreInteractions(mockUserRepository);
  });
}