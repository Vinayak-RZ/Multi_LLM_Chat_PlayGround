part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUpRequested extends AuthEvent {
  final String email;final String name;final String password;

  AuthSignUpRequested({
    required this.email, required this.password,required this.name,});
}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

final class AuthLogoutRequested extends AuthEvent {}
