import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/auth/domain/repositories/user_repository.dart';
import 'package:chatting_app/features/auth/domain/usecases/logout_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late LogoutUserUsecase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = LogoutUserUsecase(mockUserRepository);
  });

  test('should call logoutUser on the repository', () async {
    // arrange
    when(
      () => mockUserRepository.logoutUser(),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(const Right(null)));
    verify(() => mockUserRepository.logoutUser()).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return ServerFailure when repository call fails', () async {
    // arrange
    final tFailure = const ServerFailure('Logout failed');
    when(
      () => mockUserRepository.logoutUser(),
    ).thenAnswer((_) async => Left(tFailure));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(Left(tFailure)));
    verify(() => mockUserRepository.logoutUser()).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
