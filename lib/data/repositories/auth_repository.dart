import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@lazySingleton
class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signInWithApple() async {
    try {
      final appleCredentials = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredentials.identityToken,
        accessToken: appleCredentials.authorizationCode,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // update firebase user with apple account name
      final firebaseUser = userCredential.user;
      final displayName = _getAppleUserFullName(credentials: appleCredentials);
      await firebaseUser?.updateDisplayName(displayName);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  bool isAuthenticated() => _firebaseAuth.currentUser != null;

  User? getCurrentUser() => _firebaseAuth.currentUser;

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> updateProfile({
    required String name,
    required String? avatarURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('user-unauthenticated');
      }

      await user.updateDisplayName(name);
      if (avatarURL != null) {
        await user.updatePhotoURL(avatarURL);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String _getAppleUserFullName({
    required AuthorizationCredentialAppleID credentials,
  }) =>
      '${credentials.givenName ?? ''} ${credentials.familyName ?? ''}'.trim();
}
