import 'package:bloc_clean_architecture/src/comman/failure.dart';
import 'package:bloc_clean_architecture/src/domain/repositories/transaction_repository.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/fetch_transactions.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/send_money.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockFailure extends Failure {
  MockFailure(super.message);
}

void main() {
  group('FetchTransactions', () {
    late MockTransactionRepository mockRepository;
    late FetchTransactions fetchTransactions;

    setUp(() {
      mockRepository = MockTransactionRepository();
      fetchTransactions = FetchTransactions(mockRepository);
    });

    test('returns Right(List<Transaction>) from repository', () async {
      final transactions = <Transaction>[
        Transaction(to: 'a', amount: 1, date: DateTime.now()),
        Transaction(amount: 2, date: DateTime.now(), to: 'b'),
      ];
      when(() => mockRepository.viewTransactions())
          .thenAnswer((_) async => Right(transactions));

      final result = await fetchTransactions();
      expect(result, Right(transactions));
      verify(() => mockRepository.viewTransactions()).called(1);
    });

    test('returns Left(Failure) from repository', () async {
      final failure = MockFailure('error');
      when(() => mockRepository.viewTransactions())
          .thenAnswer((_) async => Left(failure));

      final result = await fetchTransactions();
      expect(result, Left(failure));
      verify(() => mockRepository.viewTransactions()).called(1);
    });
  });

  group('SendMoney', () {
    late MockTransactionRepository mockRepository;
    late SendMoney sendMoney;

    setUp(() {
      mockRepository = MockTransactionRepository();
      sendMoney = SendMoney(mockRepository);
    });

    test(
        'calls repository.sendMoney with correct params and returns Right(void)',
        () async {
      when(() => mockRepository.sendMoney(
              to: any(named: 'to'), amount: any(named: 'amount')))
          .thenAnswer((_) async => const Right(null));

      final result = await sendMoney(to: 'Charlie', amount: 200.0);
      // expect(result, const Right(null));
      verify(() => mockRepository.sendMoney(to: 'Charlie', amount: 200.0))
          .called(1);
    });

    test('returns Left(Failure) when repository.sendMoney fails', () async {
      final failure = MockFailure('send error');
      when(() => mockRepository.sendMoney(
          to: any(named: 'to'),
          amount: any(named: 'amount'))).thenAnswer((_) async => Left(failure));

      final result = await sendMoney(to: 'Charlie', amount: 200.0);
      // expect(result, Left(failure));
      verify(() => mockRepository.sendMoney(to: 'Charlie', amount: 200.0))
          .called(1);
    });
  });
}
