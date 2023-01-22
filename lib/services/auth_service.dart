import 'package:conu_hacks_2005/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static AuthService? _instance;

  static AuthService get instance => _instance ??= AuthService._();
  var googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future handleSignIn() async {
    try {
      final googleuser = await googleSignIn.signIn().catchError((onError) => print(onError));
      if (googleuser == null) {
        return;
      }
      _user = googleuser;
      final googleAuth = await googleuser.authentication;
      final credential =
          GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
        await ApiService.instance.sendUserDetails();
      }).catchError((e) {
        print("error $e");
      });
    } catch (e) {
      print(e);
    }
  }
}
