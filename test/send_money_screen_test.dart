import 'package:sample_wallet_app/src/presentation/bloc/transactions/send_money_bloc.dart';
import 'package:sample_wallet_app/src/presentation/page/send_money_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockSendMoneyBloc extends MockBloc<SendMoneyEvent, SendMoneyState>
    implements SendMoneyBloc {}

void main() {
  late SendMoneyBloc sendMoneyBloc;

  setUp(() {
    sendMoneyBloc = MockSendMoneyBloc();
  });

  tearDown(() {
    sendMoneyBloc.close();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<SendMoneyBloc>.value(
        value: sendMoneyBloc,
        child: child,
      ),
    );
  }

  testWidgets('shows form fields and send button', (tester) async {
    when(() => sendMoneyBloc.state).thenReturn(SendMoneyInitial());

    await tester.pumpWidget(makeTestableWidget(const SendMoneyScreen()));

    expect(find.text('Send Money'), findsOneWidget);
    expect(find.text('Amount to send'), findsOneWidget);
    expect(find.text('Recipient'), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
  });

  testWidgets('shows loading indicator when sending', (tester) async {
    when(() => sendMoneyBloc.state).thenReturn(SendMoneyLoading());

    await tester.pumpWidget(makeTestableWidget(const SendMoneyScreen()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows success bottom sheet when money sent', (tester) async {
    whenListen(
      sendMoneyBloc,
      Stream.fromIterable([SendMoneyInitial(), SendMoneySuccess()]),
      initialState: SendMoneyInitial(),
    );

    await tester.pumpWidget(makeTestableWidget(const SendMoneyScreen()));
    sendMoneyBloc.add(SendMoneyPressed());
    await tester.pumpAndSettle();

    expect(find.text('Money Sent Successfully!'), findsOneWidget);
  });

  testWidgets('shows error snackbar when send fails', (tester) async {
    whenListen(
      sendMoneyBloc,
      Stream.fromIterable([SendMoneyInitial(), SendMoneyFailure('Failed')]),
      initialState: SendMoneyInitial(),
    );

    await tester.pumpWidget(makeTestableWidget(const SendMoneyScreen()));
    sendMoneyBloc.add(SendMoneyPressed());
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
