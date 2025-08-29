import 'package:sample_wallet_app/src/data/datasource/authentication_remote_data_source.dart';
import 'package:sample_wallet_app/src/data/datasource/transaction_remote_data_source.dart';
import 'package:sample_wallet_app/src/data/repository/authentication_repository_impl.dart';
import 'package:sample_wallet_app/src/data/repository/transaction_repository_impl.dart';
import 'package:sample_wallet_app/src/domain/repositories/autentication_repository.dart';
import 'package:sample_wallet_app/src/domain/repositories/transaction_repository.dart';
import 'package:sample_wallet_app/src/domain/usecase/fetch_transactions.dart';
import 'package:sample_wallet_app/src/domain/usecase/login.dart';
import 'package:sample_wallet_app/src/domain/usecase/send_money.dart';
import 'package:sample_wallet_app/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:sample_wallet_app/src/presentation/bloc/sign_in_form/sign_in_form_bloc.dart';
import 'package:sample_wallet_app/src/presentation/bloc/transactions/send_money_bloc.dart';
import 'package:sample_wallet_app/src/presentation/bloc/transactions/view_transactions_bloc.dart';
import 'package:sample_wallet_app/src/presentation/cubit/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // Data sources
  final authRemoteDataSource = AuthenticationRemoteDataSourceImpl();
  locator.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => authRemoteDataSource,
  );

  locator.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(),
  );

  // Repositories
  final authRepository = AuthenticationRepositoryImpl(locator());
  locator.registerLazySingleton<AuthenticationRepository>(
    () => authRepository,
  );

  locator.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(locator<TransactionRemoteDataSource>()),
  );

  // Use cases
  final signIn = SignIn(locator());
  locator.registerLazySingleton(
    () => signIn,
  );

  final fetchTransactions = FetchTransactions(locator());
  locator.registerLazySingleton(
    () => fetchTransactions,
  );

  final sendMoney = SendMoney(locator());
  locator.registerLazySingleton(
    () => sendMoney,
  );

  // BLoCs
  final authenticatorWatcherBloc = AuthenticatorWatcherBloc();
  locator.registerLazySingleton(
    () => authenticatorWatcherBloc,
  );

  final signInFormBloc = SignInFormBloc(locator());
  locator.registerLazySingleton(
    () => signInFormBloc,
  );

  final themeCubit = ThemeCubit();
  locator.registerLazySingleton(
    () => themeCubit,
  );

  final sendMoneyBloc = SendMoneyBloc(locator<SendMoney>());
  locator.registerLazySingleton(() => sendMoneyBloc);

  final viewTransactionsBloc =
      ViewTransactionsBloc(locator<FetchTransactions>());
  locator.registerLazySingleton(() => viewTransactionsBloc);
}
