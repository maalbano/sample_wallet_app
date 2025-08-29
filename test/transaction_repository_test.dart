import 'package:sample_wallet_app/src/comman/failure.dart';

import 'package:sample_wallet_app/src/data/datasource/transaction_remote_data_source.dart';
import 'package:sample_wallet_app/src/data/repository/transaction_repository_impl.dart';
import 'package:sample_wallet_app/src/comman/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRemoteDataSource extends Mock
    implements TransactionRemoteDataSource {}

class FakeFailure extends Failure {
  FakeFailure(String message) : super(message);
}

void main() {
  group('TransactionRepositoryImpl', () {
    late MockTransactionRemoteDataSource mockDataSource;
    late TransactionRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockTransactionRemoteDataSource();
      repository = TransactionRepositoryImpl(mockDataSource);
    });

    test('returns Right(void) when sendMoney succeeds', () async {
      when(() => mockDataSource.sendMoney(
              to: any(named: 'to'), amount: any(named: 'amount')))
          .thenAnswer((_) async => const Right<Failure, void>(null));
      final result = await repository.sendMoney(to: 'Alice', amount: 100.0);
      expect(result, const Right<Failure, void>(null));
      verify(() => mockDataSource.sendMoney(to: 'Alice', amount: 100.0))
          .called(1);
    });

    test('returns Left(Failure) when sendMoney throws', () async {
      when(() => mockDataSource.sendMoney(
              to: any(named: 'to'), amount: any(named: 'amount')))
          .thenAnswer((_) async => Left(FakeFailure('error')));
      final result = await repository.sendMoney(to: 'Alice', amount: 100.0);
      expect(result, isA<Left<Failure, void>>());
    });

    test('returns Right(List<Transaction>) when viewTransactions succeeds',
        () async {
      final txs = [
        {'id': 1, 'amount': 100.0, 'to': 'Alice', 'date': '2025-08-27'},
        {'id': 2, 'amount': 50.0, 'to': 'Bob', 'date': '2025-08-26'},
      ];
      when(() => mockDataSource.fetchTransactions()).thenAnswer(
          (_) async => Right<Failure, List<Map<String, dynamic>>>(txs));
      final result = await repository.viewTransactions();

      // The repository may convert to domain models, but here we just check for a Right
      expect(result.isRight(), true);
      verify(() => mockDataSource.fetchTransactions()).called(1);
    });

    test('returns Left(Failure) when viewTransactions throws', () async {
      when(() => mockDataSource.fetchTransactions())
          .thenAnswer((_) async => Left(FakeFailure('error')));
      final result = await repository.viewTransactions();
      expect(result, isA<Left<Failure, dynamic>>());
    });
  });
}
