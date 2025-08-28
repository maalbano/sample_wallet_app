import 'package:bloc_clean_architecture/src/comman/failure.dart';
import 'package:bloc_clean_architecture/src/domain/repositories/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class Transaction {
  Transaction({
    required this.to,
    required this.amount,
    required this.date,
  });
  String to;
  double amount;
  DateTime date;
}

class FetchTransactions {
  final TransactionRepository repository;

  FetchTransactions(this.repository);

  Future<Either<Failure, List<Transaction>>> call() {
    return repository.viewTransactions();
  }
}
