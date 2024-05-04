import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:safety_app/logic/handlers/auth_ecxeption_handler.dart';

class UserProvider with ChangeNotifier {
  FirebaseAuth? _auth;
  User? _user;
  AuthStatus _status = AuthStatus.uninitialized;


  AuthStatus get status => _status;
  User? get user => _user;

  UserProvider.instance(){
    _auth = FirebaseAuth.instance;
    _auth?.authStateChanges()
        .listen((event)=>_onAuthStateChanged(event));
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      await _auth!.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on  FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
      return false;
    }
  }

  Future<bool> updateProfile(String email, String name) async {
    try {
      if(name.isNotEmpty){
        await user?.updateDisplayName(name);
      }
      if(email.isNotEmpty){
        await user?.updateEmail(email);
      }
      return true;
    } on  FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      userCredential.user?.updateDisplayName(name);
      _status = AuthStatus.unauthenticated;
      return true;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
      return false;
    } catch (e) {
      _status = AuthStatus.unknown;
      return false;
    }
  }

  Future resetPassword(String email) async {
    if(_user!=null){
      _auth?.signOut();
    }
    _auth?.sendPasswordResetEmail(email: email);
    _status = AuthStatus.unauthenticated;
    return Future.delayed(Duration.zero);
  }

  Future signOut() async {
    _auth?.signOut();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }


  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _user = firebaseUser;
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }
}