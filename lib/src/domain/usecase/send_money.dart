import 'package:bloc_clean_architecture/src/domain/repositories/transaction_repository.dart';

class SendMoney {
  SendMoney(this.repository);
  final TransactionRepository repository;

  Future<void> call({required String to, required double amount}) {
    return repository.sendMoney(to: to, amount: amount);
  }
}
