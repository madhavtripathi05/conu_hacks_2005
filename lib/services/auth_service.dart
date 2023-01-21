import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static AuthService? _instance;

  static AuthService get instance => _instance ??= AuthService._();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<void> handleSignIn() async {
    try {
      final acc = await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Stream<User?> currentUser = FirebaseAuth.instance.userChanges();
}
