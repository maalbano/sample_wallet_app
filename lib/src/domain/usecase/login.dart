import 'package:sample_wallet_app/src/comman/failure.dart';
import 'package:sample_wallet_app/src/domain/repositories/autentication_repository.dart';
import 'package:dartz/dartz.dart';

class SignIn {
  SignIn(this._repository);
  final AuthenticationRepository _repository;

  Future<Either<Failure, void>> execute(String email, String password) async {
    return _repository.login(email, password);
  }
}
