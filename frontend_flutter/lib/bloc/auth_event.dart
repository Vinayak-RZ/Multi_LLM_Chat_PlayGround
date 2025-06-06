part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String name;
  final String password;

  AuthLoginRequested({
    required this.email,
    required this.password,
    required this.name,
  });
}

final class AuthLogoutRequested extends AuthEvent {}
