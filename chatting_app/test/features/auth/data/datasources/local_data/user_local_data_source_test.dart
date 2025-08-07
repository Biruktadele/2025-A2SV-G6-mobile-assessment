import 'dart:convert';

import 'package:chatting_app/features/auth/data/datasources/local_data/user_local_data_source_impl.dart';
import 'package:chatting_app/features/auth/data/models/user_model.dart';
import 'package:chatting_app/features/auth/domain/entities/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late UserLocalDataSourceImpl dataSource;
  late MockFlutterSecureStorage mockSecureStorage;

  // Test data
  final testUser = const User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );
  const testToken = 'test_token_123';
  final testUserJson = jsonEncode(UserModel.fromEntity(testUser).toJson());

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    dataSource = UserLocalDataSourceImpl(
      flutterSecureStorage: mockSecureStorage,
    );
  });

  group('saveUser', () {
    test('should store user data in secure storage', () async {
      // arrange
      when(() => mockSecureStorage.write(
            key: 'user',
            value: testUserJson,
          )).thenAnswer((_) async => {});

      // act
      await dataSource.saveUser(testUser);

      // assert
      verify(() => mockSecureStorage.write(
            key: 'user',
            value: testUserJson,
          )).called(1);
    });
  });

  group('getUser', () {
    test('should return User when user exists in secure storage', () async {
      // arrange
      when(() => mockSecureStorage.read(key: 'user'))
          .thenAnswer((_) async => testUserJson);

      // act
      final result = await dataSource.getUser();

      // assert
      expect(result, isA<User>());
      expect(result?.id, equals(testUser.id));
      expect(result?.name, equals(testUser.name));
      expect(result?.email, equals(testUser.email));
      verify(() => mockSecureStorage.read(key: 'user')).called(1);
    });

    test('should throw exception when user does not exist', () async {
      // arrange
      when(() => mockSecureStorage.read(key: 'user'))
          .thenAnswer((_) async => null);

      // act & assert
      expect(
        () => dataSource.getUser(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'error message',
          contains('User not found'),
        )),
      );
      verify(() => mockSecureStorage.read(key: 'user')).called(1);
    });
  });

  group('deleteUser', () {
    test('should remove user data from secure storage', () async {
      // arrange
      when(() => mockSecureStorage.delete(key: 'user'))
          .thenAnswer((_) async => {});

      // act
      await dataSource.deleteUser();

      // assert
      verify(() => mockSecureStorage.delete(key: 'user')).called(1);
    });
  });

  group('saveToken', () {
    test('should store token in secure storage', () async {
      // arrange
      when(() => mockSecureStorage.write(
            key: 'token',
            value: testToken,
          )).thenAnswer((_) async => {});

      // act
      await dataSource.saveToken(testToken);

      // assert
      verify(() => mockSecureStorage.write(
            key: 'token',
            value: testToken,
          )).called(1);
    });
  });

  group('getToken', () {
    test('should return token when token exists in secure storage', () async {
      // arrange
      when(() => mockSecureStorage.read(key: 'token'))
          .thenAnswer((_) async => testToken);

      // act
      final result = await dataSource.getToken();

      // assert
      expect(result, equals(testToken));
      verify(() => mockSecureStorage.read(key: 'token')).called(1);
    });

    test('should return null when token does not exist', () async {
      // arrange
      when(() => mockSecureStorage.read(key: 'token'))
          .thenAnswer((_) async => null);

      // act
      final result = await dataSource.getToken();

      // assert
      expect(result, isNull);
      verify(() => mockSecureStorage.read(key: 'token')).called(1);
    });
  });

  group('deleteToken', () {
    test('should remove token from secure storage', () async {
      // arrange
      when(() => mockSecureStorage.delete(key: 'token'))
          .thenAnswer((_) async => {});

      // act
      await dataSource.deleteToken();

      // assert
      verify(() => mockSecureStorage.delete(key: 'token')).called(1);
    });
  });
}