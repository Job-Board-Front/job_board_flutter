import 'package:firebase_auth/firebase_auth.dart';
import '../models/current_user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory AuthService() => _instance;
  AuthService._internal();

  Stream<CurrentUser?> get authStateChanges {
    return _auth.userChanges().asyncMap((user) async {
      if (user == null) return null;
      try {
        final idToken = await user.getIdTokenResult();
        final roles =
            (idToken.claims?['roles'] as List?)?.cast<String>() ?? ['user'];
        return CurrentUser(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
          roles: roles,
        );
      } catch (e) {
        return CurrentUser(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
          roles: ['user'],
        );
      }
    });
  }

  Future<void> register(
    String email,
    String password,
    String displayName,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(displayName);
    await cred.user?.reload();
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
