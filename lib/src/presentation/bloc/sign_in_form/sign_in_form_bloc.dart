import 'package:bloc_clean_architecture/src/domain/usecase/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event definitions
abstract class SignInFormEvent {}

class EmailChanged extends SignInFormEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends SignInFormEvent {
  final String password;
  PasswordChanged(this.password);
}

class SignInPressed extends SignInFormEvent {}

// State definitions
abstract class SignInFormState {}

class SignInFormInitial extends SignInFormState {}

class SignInFormLoading extends SignInFormState {}

class SignInFormSuccess extends SignInFormState {}

class SignInFormFailure extends SignInFormState {
  final String error;
  SignInFormFailure(this.error);
}

// Bloc implementation
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  SignInFormBloc(this._signInWithEmail) : super(SignInFormInitial()) {
    on<EmailChanged>((event, emit) {
      _email = event.email;
    });

    on<PasswordChanged>((event, emit) {
      _password = event.password;
    });

    on<SignInPressed>((event, emit) async {
      emit(SignInFormLoading());
      try {
        final result = await _signInWithEmail.execute(
          _email,
          _password,
        );
        result.fold(
          (f) => emit(
            SignInFormFailure('Invalid email or password'),
          ),
          (_) => emit(SignInFormSuccess()),
        );

        // await Future.delayed(const Duration(seconds: 1));
        // if (_email == 'test@example.com' && _password == 'password') {
        //   emit(SignInFormSuccess());
        // } else {
        //   emit(SignInFormFailure('Invalid email or password'));
        // }
      } catch (e) {
        emit(SignInFormFailure('An error occurred'));
      }
    });
  }
  String _email = '';
  String _password = '';

  final SignIn _signInWithEmail;
}
