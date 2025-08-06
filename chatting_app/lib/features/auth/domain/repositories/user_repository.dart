import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> logoutUser();
  Future<Either<Failure, User>> registerUser(User user);
  Future<Either<Failure, User>> loginUser(User user);
}
