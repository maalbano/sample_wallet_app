import 'package:sample_wallet_app/src/comman/failure.dart';
import 'package:sample_wallet_app/src/domain/repositories/transaction_repository.dart';
import 'package:sample_wallet_app/src/data/datasource/transaction_remote_data_source.dart';
import 'package:sample_wallet_app/src/domain/usecase/fetch_transactions.dart';
import 'package:dartz/dartz.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> sendMoney({
    required String to,
    required double amount,
  }) {
    return remoteDataSource.sendMoney(to: to, amount: amount);
  }

  @override
  Future<Either<Failure, List<Transaction>>> viewTransactions() async {
    return (await remoteDataSource.fetchTransactions()).fold(
      (l) => Left(l),
      (r) {
        List<Transaction> out = [];
        for (final item in r) {
          out.add(Transaction(
            to: '${item['to']}',
            amount: double.tryParse('${item['amount']}') ?? 0.0,
            date: DateTime.parse('${item['date']}') ?? DateTime.now(),
          ));
        }
        return Right(out);
      },
    );
  }
}
