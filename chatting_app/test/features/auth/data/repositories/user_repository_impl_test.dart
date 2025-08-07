import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/network/network.dart';
import 'package:chatting_app/features/auth/data/datasources/local_data/user_local_data_source.dart';
import 'package:chatting_app/features/auth/data/datasources/remote_data/user_remote_data_source.dart';
import 'package:chatting_app/features/auth/data/models/user_model.dart';
import 'package:chatting_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:chatting_app/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_impl_test.mocks.dart';

// To regenerate mocks, run:
// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([
  UserRemoteDataSource,
  UserLocalDataSource,
  NetworkInfo,
])
void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockUserLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  
  // Test data
  final tUser = const User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );
  final tUserModel = UserModel.fromEntity(tUser);
  final tException = Exception('Test exception');

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockLocalDataSource = MockUserLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('loginUser', () {
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.loginUser(any))
              .thenAnswer((_) async => tUserModel);
          
          // act
          final result = await repository.loginUser(tUser);
          
          // assert
          verify(mockRemoteDataSource.loginUser(tUserModel));
          expect(result, equals(Right(tUserModel)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.loginUser(any)).thenThrow(tException);
          
          // act
          final result = await repository.loginUser(tUser);
          
          // assert
          verify(mockRemoteDataSource.loginUser(tUserModel));
          expect(result, equals(Left(ServerFailure(tException.toString()))));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return offline failure when there is no internet connection',
        () async {
          // act
          final result = await repository.loginUser(tUser);
          
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(const Left(OfflineFailure('user is offline'))));
        },
      );
    });
  });

  group('registerUser', () {
    runTestsOnline(() {
      test(
        'should return user when registration is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.registerUser(any))
              .thenAnswer((_) async => tUserModel);
          
          // act
          final result = await repository.registerUser(tUser);
          
          // assert
          verify(mockRemoteDataSource.registerUser(tUserModel));
          expect(result, equals(Right(tUserModel)));
        },
      );

      test(
        'should return server failure when registration fails',
        () async {
          // arrange
          when(mockRemoteDataSource.registerUser(any)).thenThrow(tException);
          
          // act
          final result = await repository.registerUser(tUser);
          
          // assert
          verify(mockRemoteDataSource.registerUser(tUserModel));
          expect(result, equals(Left(ServerFailure(tException.toString()))));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return offline failure when there is no internet connection',
        () async {
          // act
          final result = await repository.registerUser(tUser);
          
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(const Left(OfflineFailure('user is offline'))));
        },
      );
    });
  });

  group('logoutUser', () {
    runTestsOnline(() {
      test(
        'should return void when logout is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.deleteToken()).thenAnswer((_) async {});
          
          // act
          final result = await repository.logoutUser();
          
          // assert
          verify(mockRemoteDataSource.deleteToken());
          expect(result, const Right(null));
        },
      );

      test(
        'should return server failure when logout fails',
        () async {
          // arrange
          when(mockRemoteDataSource.deleteToken()).thenThrow(tException);
          
          // act
          final result = await repository.logoutUser();
          
          // assert
          verify(mockRemoteDataSource.deleteToken());
          expect(result, equals(Left(ServerFailure(tException.toString()))));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return offline failure when there is no internet connection',
        () async {
          // act
          final result = await repository.logoutUser();
          
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(const Left(OfflineFailure('user is offline'))));
        },
      );
    });
  });
}
