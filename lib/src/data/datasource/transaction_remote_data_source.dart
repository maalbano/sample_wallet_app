import 'package:sample_wallet_app/src/comman/api.dart';
import 'package:sample_wallet_app/src/comman/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class TransactionRemoteDataSource {
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchTransactions();
  Future<Either<Failure, void>> sendMoney(
      {required String to, required double amount});
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchTransactions() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(API.FETCH_TRANSACTIONS, data: {});

    // await Future.delayed(const Duration(milliseconds: 500));
    return const Right([
      {'id': 1, 'amount': 100.0, 'to': 'Alice', 'date': '2025-08-27'},
      {'id': 2, 'amount': 50.0, 'to': 'Bob', 'date': '2025-08-26'},
    ]);
  }

  @override
  Future<Either<Failure, void>> sendMoney(
      {required String to, required double amount}) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(API.SEND_MONEY, data: {});

    if (response.statusCode == 200) {
      return const Right(null);
    } else {
      return const Left(ServerFailure('Failed to send money'));
    }
  }
}
