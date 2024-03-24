import 'package:firebase_auth/firebase_auth.dart';

import '../auth_ecxeption_handler.dart';

class AuthService {

  AuthService._();
  static final AuthService auth = AuthService._();

  //use _ for private variables
  static final FirebaseAuth _authInstance = FirebaseAuth.instance;

  Future<void> logout() async{
    await _authInstance!.signOut();
  }

  Future<AuthStatus> login(String email, String password) async{
    try {
      await _authInstance!.signInWithEmailAndPassword(email: email, password: password);
      return AuthStatus.successful;
    } on  FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleAuthException(e);
    }
  }

  Future<AuthStatus> register(String email, String password, String name) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      userCredential.user?.updateDisplayName(name);
      return AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      return AuthStatus.unknown;
    }
  }

  Future<AuthStatus> resetPassword(String email) async {
    try{
      _authInstance!
          .sendPasswordResetEmail(email: email);
      return AuthStatus.successful;
    }on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      return AuthStatus.unknown;
    }
  }

  Future<AuthStatus> updateProfile(String name, String email, String password) async {
    try{
      await _authInstance!.currentUser?.updateDisplayName(name);
      await _authInstance!.currentUser?.updatePassword(password);
      await _authInstance!.currentUser?.updateEmail(email);
      return AuthStatus.successful;
    }on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      return AuthStatus.unknown;
    }
  }

  bool isAuthorized(){
    bool isAuth = false;
    _authInstance!
        .authStateChanges()
        .listen((User? user) {
      if (user != null) {
        isAuth = true;
      }
    });
    return isAuth;
  }

  User? getCurrentUser(){
    return _authInstance!.currentUser;
  }
}
