import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_event.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_state.dart';
import 'package:bloc_clean_architecture/src/presentation/page/dashboard/dashboard_screen.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticatorWatcherBloc
    extends MockBloc<AuthenticatorWatcherEvent, AuthenticatorWatcherState>
    implements AuthenticatorWatcherBloc {}

class MockSendMoneyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text('Send Money Screen');
  }
}

class MockTransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text('Transaction Screen');
  }
}

// A fake AuthenticatorWatcherEvent for mocktail fallback
class _FakeAuthenticatorWatcherEvent extends AuthenticatorWatcherEvent {}

void main() {
  late AuthenticatorWatcherBloc authenticatorWatcherBloc;

  setUpAll(() {
    // Register a fallback value for AuthenticatorWatcherEvent for mocktail
    registerFallbackValue(_FakeAuthenticatorWatcherEvent());
  });

  setUp(() {
    authenticatorWatcherBloc = MockAuthenticatorWatcherBloc();
  });

  tearDown(() {
    authenticatorWatcherBloc.close();
  });

  Widget makeTestableWidget(Widget child) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => child,
        ),
        GoRoute(
          path: AppRoutes.LOGIN_ROUTE_PATH,
          name: AppRoutes.LOGIN_ROUTE_NAME,
          builder: (context, state) {
            return const Text('Login Screen');
          },
        ),
        GoRoute(
          name: AppRoutes.SEND_MONEY_ROUTE_NAME,
          path: AppRoutes.SEND_MONEY_ROUTE_PATH,
          builder: (BuildContext context, GoRouterState state) {
            return MockSendMoneyScreen();
          },
        ),
        GoRoute(
          name: AppRoutes.VIEW_TRANSACTIONS_ROUTE_NAME,
          path: AppRoutes.VIEW_TRANSACTIONS_ROUTE_PATH,
          builder: (BuildContext context, GoRouterState state) {
            return MockTransactionScreen();
          },
        ),
      ],
    );
    return MaterialApp.router(
      routerConfig: router,
      builder: (context, widget) =>
          BlocProvider<AuthenticatorWatcherBloc>.value(
        value: authenticatorWatcherBloc,
        child: widget!,
      ),
    );
  }

  testWidgets('renders dashboard screen widgets', (tester) async {
    when(() => authenticatorWatcherBloc.state).thenReturn(AuthInitial());

    await tester.pumpWidget(makeTestableWidget(const DashBoardScreen()));

    expect(find.text('Your Account'), findsOneWidget);
    expect(find.text('Current Balance'), findsOneWidget);
    expect(find.text('Send Money'), findsOneWidget);
    expect(find.text('View Transactions'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
  });

  testWidgets('toggles balance visibility when tapped', (tester) async {
    when(() => authenticatorWatcherBloc.state).thenReturn(AuthInitial());
    await tester.pumpWidget(makeTestableWidget(const DashBoardScreen()));

    // Initially hidden
    expect(find.text('Php ********'), findsOneWidget);
    expect(find.text('Php 500.00'), findsNothing);

    // Tap to show
    await tester.tap(find.byType(ListTile));
    await tester.pump();
    expect(find.text('Php 500.00'), findsOneWidget);
    expect(find.text('Php ********'), findsNothing);
  });

  testWidgets('navigates to send money ', (tester) async {
    when(() => authenticatorWatcherBloc.state).thenReturn(AuthInitial());
    await tester.pumpWidget(makeTestableWidget(const DashBoardScreen()));

    await tester.tap(find.text('Send Money'));
    await tester.pumpAndSettle();

    expect(find.byType(MockSendMoneyScreen), findsOneWidget);
  });

  testWidgets('navigates to view transactions', (tester) async {
    when(() => authenticatorWatcherBloc.state).thenReturn(AuthInitial());
    await tester.pumpWidget(makeTestableWidget(const DashBoardScreen()));

    await tester.tap(find.text('View Transactions'));
    await tester.pumpAndSettle();

    expect(find.byType(MockTransactionScreen), findsOneWidget);
  });

  testWidgets('dispatches SignedOut event on log out', (tester) async {
    when(() => authenticatorWatcherBloc.state).thenReturn(AuthInitial());
    await tester.pumpWidget(makeTestableWidget(const DashBoardScreen()));

    await tester.tap(find.text('Log Out'));
    await tester.pump();
    verify(() => authenticatorWatcherBloc.add(any(that: isA<SignedOut>())))
        .called(1);
  });
}
