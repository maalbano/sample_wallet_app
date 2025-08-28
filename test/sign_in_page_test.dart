import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/sign_in_form/sign_in_form_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/page/auth/sign_in_screen.dart';
import 'package:bloc_clean_architecture/src/presentation/page/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockSignInFormBloc extends MockBloc<SignInFormEvent, SignInFormState>
    implements SignInFormBloc {}

void main() {
  late SignInFormBloc signInFormBloc;

  setUp(() {
    signInFormBloc = MockSignInFormBloc();
  });

  tearDown(() {
    signInFormBloc.close();
  });

  Widget makeTestableWidget(Widget child) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => child,
        ),
        GoRoute(
          name: AppRoutes.DASHBOARD_ROUTE_NAME,
          path: AppRoutes.DASHBOARD_ROUTE_PATH,
          builder: (context, state) => const DashBoardScreen(),
        ),
        // Add other routes as needed for navigation tests
      ],
    );
    return BlocProvider<SignInFormBloc>.value(
      value: signInFormBloc,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  // Widget makeTestableWidget(Widget child) {
  //   return MaterialApp(
  //     home:
  //   );
  // }

  testWidgets('renders email and password fields and sign in button',
      (tester) async {
    when(() => signInFormBloc.state).thenReturn(SignInFormInitial());

    await tester.pumpWidget(makeTestableWidget(const SignInPage()));

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('navigates to dashboard on success', (tester) async {
    whenListen(
      signInFormBloc,
      Stream.fromIterable([SignInFormInitial(), SignInFormSuccess()]),
      initialState: SignInFormInitial(),
    );

    await tester.pumpWidget(makeTestableWidget(const SignInPage()));
    signInFormBloc.add(SignInPressed());
    await tester.pumpAndSettle();

    // You may want to check for navigation or a widget on the dashboard screen.
    // For now, just check that the page is still present.
    expect(find.byType(DashBoardScreen), findsOneWidget);
  });

  testWidgets('shows error toast on failure', (tester) async {
    whenListen(
      signInFormBloc,
      Stream.fromIterable([SignInFormInitial(), SignInFormFailure('Invalid')]),
      initialState: SignInFormInitial(),
    );

    await tester.pumpWidget(makeTestableWidget(const SignInPage()));
    signInFormBloc.add(SignInPressed());
    await tester.pumpAndSettle();

    expect(find.text('Invalid'), findsOneWidget);
  });
}
