import 'package:sample_wallet_app/src/domain/usecase/fetch_transactions.dart';
import 'package:sample_wallet_app/src/presentation/bloc/transactions/view_transactions_bloc.dart';
import 'package:sample_wallet_app/src/presentation/page/view_transactions_screen.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Bloc
class MockViewTransactionsBloc
    extends MockBloc<ViewTransactionsEvent, ViewTransactionsState>
    implements ViewTransactionsBloc {}

void main() {
  late ViewTransactionsBloc viewTransactionsBloc;

  setUp(() {
    viewTransactionsBloc = MockViewTransactionsBloc();
  });

  tearDown(() {
    viewTransactionsBloc.close();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<ViewTransactionsBloc>.value(
        value: viewTransactionsBloc,
        child: child,
      ),
    );
  }

  testWidgets('shows loading indicator when loading', (tester) async {
    when(() => viewTransactionsBloc.state).thenReturn(TransactionsLoading());

    await tester.pumpWidget(makeTestableWidget(const ViewTransactionScreen()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows list of transactions when loaded', (tester) async {
    final transactions = [
      Transaction(to: 'Alice', amount: 100.0, date: DateTime.now()),
      Transaction(to: 'Bob', amount: 50.0, date: DateTime.now()),
    ];
    when(() => viewTransactionsBloc.state)
        .thenReturn(TransactionsLoaded(transactions));

    await tester.pumpWidget(makeTestableWidget(const ViewTransactionScreen()));

    expect(find.text('To: Alice'), findsOneWidget);
    expect(find.text('To: Bob'), findsOneWidget);
    expect(find.text('Amount: Php 100.0'), findsOneWidget);
    expect(find.text('Amount: Php 50.0'), findsOneWidget);
  });

  testWidgets('shows no transactions found when loaded with empty list',
      (tester) async {
    when(() => viewTransactionsBloc.state).thenReturn(TransactionsLoaded([]));

    await tester.pumpWidget(makeTestableWidget(const ViewTransactionScreen()));

    expect(find.text('No transactions found.'), findsOneWidget);
  });

  testWidgets('shows error message when error state', (tester) async {
    when(() => viewTransactionsBloc.state)
        .thenReturn(TransactionsError('Failed to fetch'));

    await tester.pumpWidget(makeTestableWidget(const ViewTransactionScreen()));

    expect(find.text('Error: Failed to fetch'), findsOneWidget);
  });
}
