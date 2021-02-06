import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum AuthStatus {signedIn, notSignedIn}

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm =  FirebaseMessaging();

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

  Future<FirebaseUser> emailSignUp(String _email, String _pass) async{
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
      'displayName': user.displayName ?? user.email,
      'email': user.email,
      'photoURL': user.photoUrl,
      'uid': user.uid,
      'lastSeen': DateTime.now()
    },merge: true);

    _saveDeviceToken();
  }
  
  Future<FirebaseUser> getUser() async{
    FirebaseUser user = await _auth.currentUser();
    return user;
  }

  Stream<QuerySnapshot> getBins(){
    // returns bins collection stream
    return _db.collection('bins').snapshots();
  }

  Future<QuerySnapshot> getBinsForMap() async{
    // returns bins collection future
    final bins = await _db.collection('bins').snapshots();
    return bins.first;
  }

  _saveDeviceToken() async {
    // Get the current user
    FirebaseUser user = await _auth.currentUser();
    String uid = user.uid;

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  updatePhoneNumber(String phone) async {
    FirebaseUser user = await _auth.currentUser();
    _db.collection('users').document(user.uid).setData({
      'phoneNumber' : phone
    } ,merge:true);
    return user;
  }

  signOut(){
    _auth.signOut();
    print('Signed out');
  }

  getPhone() async{
    String _phn = "";
    FirebaseUser user = await _auth.currentUser();
    var snap = await _db.collection('users').document(user.uid).snapshots();
    await snap.first.then((val){
      _phn = val['phoneNumber'];
    });
    return _phn;
  }
}

final AuthService authService = AuthService();