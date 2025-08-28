import 'package:bloc_clean_architecture/src/domain/usecase/fetch_transactions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event
abstract class ViewTransactionsEvent {}

class LoadTransactions extends ViewTransactionsEvent {}

// State
abstract class ViewTransactionsState {}

class TransactionsInitial extends ViewTransactionsState {}

class TransactionsLoading extends ViewTransactionsState {}

class TransactionsLoaded extends ViewTransactionsState {
  // Replace dynamic with your Transaction model
  TransactionsLoaded(this.transactions);
  final List<Transaction> transactions;
}

class TransactionsError extends ViewTransactionsState {
  TransactionsError(this.message);
  final String message;
}

// Bloc
class ViewTransactionsBloc
    extends Bloc<ViewTransactionsEvent, ViewTransactionsState> {
  ViewTransactionsBloc(this.fetchTransactions) : super(TransactionsInitial()) {
    on<LoadTransactions>((event, emit) async {
      emit(TransactionsLoading());
      try {
        final result = await fetchTransactions.call();

        result.fold(
          (failure) => emit(TransactionsError('Failed to fetch transactions')),
          (transactions) => emit(TransactionsLoaded(transactions)),
        );
      } catch (e) {
        emit(TransactionsError(e.toString()));
      }
    });
  }

  FetchTransactions fetchTransactions;
}
