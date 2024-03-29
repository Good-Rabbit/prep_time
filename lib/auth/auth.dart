import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  static String? _uid;
  String? _userEmail;

// * Google sign in
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _username;
  String? _imageUrl;

  User? getCurrentUser() {
    return _currentUser;
  }

  String? getUserImageUrl() {
    return _imageUrl;
  }

  static String? getUid() {
    return _uid;
  }

  String? getUserEmail() {
    return _userEmail;
  }

  String? getUsername() {
    return _username;
  }

  AuthProvider() {
    _currentUser = _auth.currentUser;
    _uid = _currentUser?.uid;
    _username = _currentUser?.displayName;
    _userEmail = _currentUser?.email;
    _imageUrl = _currentUser?.photoURL;
  }

  Future<String> registerWithEmailPassword(
      String email, String password) async {
    User? user;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (user != null) {
        _uid = user.uid;
        _userEmail = user.email;
        await signInWithEmailPassword(email, password);
        return 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for that email.';
      }
    } catch (e) {
      log(e.toString());
      return 'Something went wrong';
    }
    return 'Something went wrong';
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    User? user;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;

      if (user != null) {
        _uid = user.uid;
        _userEmail = user.email;
        _currentUser = user;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auth', true);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided.');
      }
    }

    notifyListeners();

    return user;
  }

  Future<User?> signInWithGoogle() async {
    User? user;

    if (kIsWeb) {
      // The `GoogleAuthProvider` can only be used while running on the web
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        log(e.toString());
      }
    } else if (Platform.isAndroid) {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // handle the error here
          } else if (e.code == 'invalid-credential') {
            // handle the error here
          }
        } catch (e) {
          // handle the error here
        }
      }
    }

    if (user != null) {
      _uid = user.uid;
      _username = user.displayName;
      _userEmail = user.email;
      _imageUrl = user.photoURL;
      _currentUser = user;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('auth', true);
      log("User signed in");
    }

    notifyListeners();

    return user;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);

    _uid = null;
    _username = null;
    _userEmail = null;
    _imageUrl = null;
    _currentUser = null;

    Restart.restartApp(webOrigin: kIsWeb ? Uri.base.origin.toString() : null);

    log("User signed out");
  }
}
