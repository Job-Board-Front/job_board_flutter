import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial()) {
    authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthInitial());
      }
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      emit(AuthLoading());
      await authService.register(email, password, displayName);
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      await authService.login(email, password);
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await authService.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
