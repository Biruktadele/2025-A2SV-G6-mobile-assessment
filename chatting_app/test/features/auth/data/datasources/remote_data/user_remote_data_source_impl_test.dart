import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chatting_app/features/auth/data/datasources/remote_data/user_remote_data_source_impl.dart';
import 'package:chatting_app/features/auth/domain/entities/user.dart';
import 'package:chatting_app/features/auth/data/models/user_model.dart';
import 'package:chatting_app/core/constants/api_constant.dart';

import 'user_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([http.Client, FlutterSecureStorage])
void main() {
  late UserRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;
  late MockFlutterSecureStorage mockSecureStorage;
  
  // Test data
  final tUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );
  final tUserModel = UserModel.fromEntity(tUser);
  final tToken = 'test_token';
  final tJsonResponse = {
    'id': '1',
    'name': 'Test User',
    'email': 'test@example.com',
    'password': 'password123',
  };

  setUp(() {
    mockHttpClient = MockClient();
    mockSecureStorage = MockFlutterSecureStorage();
    dataSource = UserRemoteDataSourceImpl(
      client: mockHttpClient,
      secureStorage: mockSecureStorage,
    );
  });

  group('getUser', () {
    test(
      'should return user when the call to remote data source is successful',
      () async {
        // arrange
        when(mockSecureStorage.read(key: anyNamed('key')))
            .thenAnswer((_) async => tToken);
        when(
          mockHttpClient.get(
            any,
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(tJsonResponse), 200),
        );

        // act
        final result = await dataSource.getUser();

        // assert
        expect(result, equals(tUserModel));
        verify(mockSecureStorage.read(key: 'auth_token'));
        verify(
          mockHttpClient.get(
            Uri.parse('$baseUrl/users/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $tToken',
            },
          ),
        );
      },
    );

    test(
      'should throw an exception when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockSecureStorage.read(key: anyNamed('key')))
            .thenAnswer((_) async => tToken);
        when(
          mockHttpClient.get(
            any,
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => http.Response('Error', 404));

        // act
        final call = dataSource.getUser;

        // assert
        expect(() => call(), throwsA(isA<Exception>()));
      },
    );
  });

  group('registerUser', () {
    test(
      'should return user when registration is successful',
      () async {
        // arrange
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(tJsonResponse), 200),
        );

        // act
        final result = await dataSource.registerUser(tUser);

        // assert
        expect(result, equals(tUserModel));
        verify(
          mockHttpClient.post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(tUserModel.toRegisterJson()),
          ),
        );
      },
    );
  });

  group('loginUser', () {
    test(
      'should return user and save token when login is successful',
      () async {
        // arrange
        final loginResponse = {
          ...tJsonResponse,
          'token': tToken,
        };
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(loginResponse), 200),
        );
        when(mockSecureStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        )).thenAnswer((_) async => {});

        // act
        final result = await dataSource.loginUser(tUser);

        // assert
        expect(result, equals(tUserModel));
        verify(
          mockHttpClient.post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(tUserModel.toLoginJson()),
          ),
        );
        verify(mockSecureStorage.write(key: 'auth_token', value: tToken));
      },
    );
  });

  // ... rest of the token operation tests remain the same
  group('token operations', () {
    test(
      'should save token to secure storage',
      () async {
        // arrange
        when(mockSecureStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        )).thenAnswer((_) async => {});

        // act
        await dataSource.saveToken(tToken);

        // assert
        verify(mockSecureStorage.write(key: 'auth_token', value: tToken));
      },
    );

    test(
      'should get token from secure storage',
      () async {
        // arrange
        when(mockSecureStorage.read(key: anyNamed('key')))
            .thenAnswer((_) async => tToken);

        // act
        final result = await dataSource.getToken();

        // assert
        expect(result, equals(tToken));
        verify(mockSecureStorage.read(key: 'auth_token'));
      },
    );

    test(
      'should delete token from secure storage',
      () async {
        // arrange
        when(mockSecureStorage.delete(key: anyNamed('key')))
            .thenAnswer((_) async => {});

        // act
        await dataSource.deleteToken();

        // assert
        verify(mockSecureStorage.delete(key: 'auth_token'));
      },
    );
  });
}