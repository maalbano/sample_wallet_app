abstract class AuthenticatorWatcherState {}

class AuthInitial extends AuthenticatorWatcherState {}

class Authenticating extends AuthenticatorWatcherState {}

class Authenticated extends AuthenticatorWatcherState {}

class Unauthenticated extends AuthenticatorWatcherState {}

class IsFirstTime extends AuthenticatorWatcherState {}
