import 'package:bloc_clean_architecture/src/comman/failure.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/fetch_transactions.dart';
import 'package:dartz/dartz.dart';

abstract class TransactionRepository {
  Future<Either<Failure, void>> sendMoney({
    required String to,
    required double amount,
  });
  Future<Either<Failure, List<Transaction>>> viewTransactions();
}
