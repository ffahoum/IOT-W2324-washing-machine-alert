import 'package:firebase_auth/firebase_auth.dart';

// TODO: Add loading indicator for each logging function.
// TOFO: Entervalid email an passwor indicates red under the text box.
enum AuthStatus {
  success,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  passwordsMismatch,
  genericError
}

class AuthService {

  static Future<AuthStatus> signUp(String email, String password, String confirmedPassword) async {
    try {
      if (password == confirmedPassword) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        return AuthStatus.success;
      }
      else {
        await Future.delayed(const Duration(seconds: 1));
        return _handleAuthError('passwords-mismtach');
      }
    } on FirebaseAuthException catch (error) {
      return _handleAuthError(error);
    }
  }

  static Future<AuthStatus> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return AuthStatus.success;
    } on FirebaseAuthException catch (error) {
      return _handleAuthError(error);
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      return _handleAuthError(error);
    }
  }

  static dynamic _handleAuthError(dynamic error) {
    AuthStatus errorCode = AuthStatus.genericError;
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          errorCode = AuthStatus.userNotFound;
          break;
        case 'wrong-password':
          errorCode = AuthStatus.wrongPassword;
          break;
        case 'email-already-in-use':
          errorCode = AuthStatus.emailAlreadyInUse;
          break;
        case 'invalid-email':
          errorCode = AuthStatus.invalidEmail;
          break;
        case 'weak-password':
          errorCode = AuthStatus.weakPassword;
          break;
        case 'passwords-mismtach':
          errorCode = AuthStatus.passwordsMismatch;
          break;
        default:
          errorCode = AuthStatus.genericError;
          break;
      }
    } else if (error is String) {
      errorCode = AuthStatus.passwordsMismatch;
    }
    return errorCode;
  }

  static String getErrorMessage(AuthStatus errorCode) {
    switch (errorCode) {
      case AuthStatus.success:
        return 'Suceess!';
      case AuthStatus.userNotFound:
        return 'No user found for that email.';
      case AuthStatus.wrongPassword:
        return 'Wrong password provided for that email.';
      case AuthStatus.emailAlreadyInUse:
        return 'The account already exists for that email.';
      case AuthStatus.invalidEmail:
        return 'The email address is invalid';
      case AuthStatus.weakPassword:
        return 'The password provided is too weak';
      case AuthStatus.passwordsMismatch:
        return 'passwords don\'t match!';
      case AuthStatus.genericError:
        return 'An error occurred. Please try again later.';
    }
  }
}

