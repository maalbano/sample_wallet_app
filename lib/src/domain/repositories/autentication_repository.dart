import 'package:sample_wallet_app/src/comman/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, void>> login(String email, String password);
}
