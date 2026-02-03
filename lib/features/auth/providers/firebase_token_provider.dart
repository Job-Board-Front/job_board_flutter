import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_board_flutter/core/dio_interceptors.dart';

class FirebaseTokenProvider implements TokenProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<String?> getToken() async {
    // forceRefresh: false gets the cached token if valid
    return await _auth.currentUser?.getIdToken(false);
  }

  @override
  Future<String?> refreshToken() async {
    try {
      // forceRefresh: true forces a refresh from the server
      return await _auth.currentUser?.getIdToken(true);
    } catch (e) {
      return null;
    }
  }
}
