import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

enum AuthStatus {signedIn, notSignedIn}

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user;
  Observable<Map<String,dynamic>> profile;
  PublishSubject loading = PublishSubject();

  AuthService(){
    print('AuthService() constructor');
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u){
      if(u!=null){
        print('u!=null');
        return _db.collection('users').document(u.uid).snapshots().map((snap) => snap.data);
      }else{
        print('else');
        return Observable.just({ });
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async{
    loading.add(true);
    print('Attempting google sign in');

    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;


    AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    updateUserData(user);
    print('Signed in ${user.displayName}');

    loading.add(false);
    return user;
  }

  Future<FirebaseUser> emailSignIn(String _email, String _pass) async{
    loading.add(true);

    FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: _email, password: _pass)).user;

    updateUserData(user);
    print('Signed in ${user.displayName}');

    loading.add(false);
    return user;
  }

  emailSignUp(String _email, String _pass) async{
    loading.add(true);
    print('Signing up');

    FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: _email, password: _pass)).user;
    print('Updating user');
    updateUserData(user);
    print('Signed up ${user.displayName}');

    loading.add(false);
    return user;
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _auth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  updateUserData(FirebaseUser user) async{
    DocumentReference ref = _db.collection('users').document(user.uid);

    ref.setData({
      'displayName': user.displayName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'photoURL': user.photoUrl,
      'uid': user.uid,
      'lastSeen': DateTime.now()
    },merge: true);
  }
  
  Future<FirebaseUser> getUser() async{
    FirebaseUser user = await _auth.currentUser();
  }

  Stream<QuerySnapshot> getBins(){
    print('getBins() called');
    return _db.collection('bins').snapshots();
  }

  signOut(){
    _auth.signOut();
    print('Signed out');
  }
}

final AuthService authService = AuthService();