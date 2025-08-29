import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_wallet_app/src/domain/usecase/send_money.dart';

// Events
abstract class SendMoneyEvent {}

class AmountChanged extends SendMoneyEvent {
  final String amount;
  AmountChanged(this.amount);
}

class RecipientChanged extends SendMoneyEvent {
  final String recipient;
  RecipientChanged(this.recipient);
}

class SendMoneyPressed extends SendMoneyEvent {}

// States
abstract class SendMoneyState {}

class SendMoneyInitial extends SendMoneyState {}

class SendMoneyLoading extends SendMoneyState {}

class SendMoneySuccess extends SendMoneyState {}

class SendMoneyFailure extends SendMoneyState {
  final String error;
  SendMoneyFailure(this.error);
}

// Bloc
class SendMoneyBloc extends Bloc<SendMoneyEvent, SendMoneyState> {
  final SendMoney sendMoneyUsecase;
  String _amount = '';
  String _recipient = '';

  SendMoneyBloc(this.sendMoneyUsecase) : super(SendMoneyInitial()) {
    on<AmountChanged>((event, emit) {
      _amount = event.amount;
    });

    on<RecipientChanged>((event, emit) {
      _recipient = event.recipient;
    });

    on<SendMoneyPressed>((event, emit) async {
      emit(SendMoneyLoading());
      try {
        final amount = double.tryParse(_amount) ?? 0.0;
        if (_recipient.isEmpty || amount <= 0) {
          emit(SendMoneyFailure('Please enter a valid recipient and amount.'));
          return;
        }
        await sendMoneyUsecase(to: _recipient, amount: amount);
        emit(SendMoneySuccess());
      } catch (e) {
        emit(SendMoneyFailure('Failed to send money.'));
      }
    });
  }
}
