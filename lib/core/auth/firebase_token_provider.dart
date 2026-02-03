import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_board_flutter/core/dio_interceptors.dart';

/// Token provider that retrieves Firebase ID tokens for authentication
class FirebaseTokenProvider implements TokenProvider {
  final FirebaseAuth _auth;

  FirebaseTokenProvider(this._auth);

  @override
  Future<String?> getToken() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      
      final token = await user.getIdToken();
      return token;
    } catch (e) {
      print('Error getting Firebase token: $e');
      return null;
    }
  }

  @override
  Future<String?> refreshToken() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      
      // Force refresh the token
      final token = await user.getIdToken(true);
      return token;
    } catch (e) {
      print('Error refreshing Firebase token: $e');
      return null;
    }
  }
}
