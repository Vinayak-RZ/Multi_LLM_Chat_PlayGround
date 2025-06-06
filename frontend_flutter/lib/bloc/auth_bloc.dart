import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  // @override
  // void onChange(Change<AuthState> change) {
  //   super.onChange(change);
  //   print('AuthBloc - Change - $change');
  // }

  // @override
  // void onTransition(Transition<AuthEvent, AuthState> transition) {
  //   super.onTransition(transition);
  //   print('AuthBloc - Transition - $transition');
  // }

  void _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final email = event.email;
    final password = event.password;
    final name = event.name;

    // Simple password length validation
    if (password.length < 6) {
      emit(AuthFailure('Password cannot be less than 6 characters!'));
      return;
    }

    try {
      final url = Uri.parse('http://localhost:5261/signup');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'name': name}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          emit(
            AuthSuccess("Registration successful! Please log in."), 
          ); //will replace with uid if needed anywhere(will have to change user model)
        } else {
          emit(AuthFailure(data['message'] ?? 'Registration failed.'));
        }
      } else {
        final data = jsonDecode(response.body);
        emit(
          AuthFailure(
            data['message'] ?? 'Server error: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      emit(AuthFailure('Exception: $e'));
    }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 1), () {
        return emit(AuthInitial());
      });
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
