// ignore_for_file: always_use_package_imports

import 'package:bloc_clean_architecture/src/comman/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authenticator_watcher_event.dart';
import 'authenticator_watcher_state.dart';

class AuthenticatorWatcherBloc
    extends Bloc<AuthenticatorWatcherEvent, AuthenticatorWatcherState> {
  AuthenticatorWatcherBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      emit(Authenticating());
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ACCESS_TOKEN);
      final showOnboarding = prefs.getString(ONBOARDING);
      if (showOnboarding == null) {
        await prefs.setString(ONBOARDING, ONBOARDING);
        emit(IsFirstTime());
      } else if (token != null) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });

    on<SignedOut>((event, emit) async {
      emit(Authenticating());
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ACCESS_TOKEN);
      emit(Unauthenticated());
    });
  }
}
