import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/user.dart';
import '../repository/auth_repo.dart';

class LoginUser extends UseCase<User, Map> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, User>> call(Map authData) async {
    return await repository.loginUser(authData: authData);
  }
}
