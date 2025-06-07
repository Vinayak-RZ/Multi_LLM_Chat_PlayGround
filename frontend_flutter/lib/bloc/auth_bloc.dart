import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final storage = FlutterSecureStorage();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<LoginRequested>(_onLoginRequested);
  }
  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final email = event.email;
    final password = event.password;

    // Simple password length validation
    if (password.length < 6) {
      emit(AuthFailure('Password cannot be less than 6 characters!'));
      return;
    }

    try {
      final url = Uri.parse('http://localhost:5261/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        emit(AuthSuccess("Login successful!"));
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        //storing token in secure storage
        await storage.write(key: 'auth_token', value: token);
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

  void _onAuthSignUpRequested(
    AuthSignUpRequested event,
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
      final storage = FlutterSecureStorage();
      await storage.delete(key: 'auth_token'); 

      emit(AuthInitial()); 
    } catch (e) {
      emit(AuthFailure('Logout failed: ${e.toString()}'));
    }
  }
}
