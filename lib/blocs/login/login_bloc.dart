import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/login/login_validators.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beacon_bus/constants.dart';


class LoginBloc extends Object with LoginValidators {
  BuildContext _context;
  SharedPreferences prefs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();


  LoginBloc() {
    loadSharedPrefs();
  }

  Observable<String> get email => _email.stream.transform(validateEmail);
  Observable<String> get password => _password.stream.transform(validatePassword);
  Observable<String> get submitValid => Observable.combineLatest2(email, password, (e, p) => "" + e + p);

  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  submit() {
    final validEmail = _email.value;
    final validPassword = _password.value;

    _auth.signInWithEmailAndPassword(email: validEmail, password: validPassword)
        .then((FirebaseUser user) {
      Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(user.uid).get().then((snapshot) {
        String userType = snapshot.data['type'];
        String userName = snapshot.data['name'];
        String userClass = snapshot.data['class'];
        String childId = snapshot.data['childId'];
        prefs.setString(USER_NAME, userName);
        prefs.setString(USER_CLASS, userClass);
        prefs.setString(USER_ID, user.uid);
        prefs.setString(CHILD_ID, childId);
          if (userType == "parent") {
            prefs.setString(USER_TYPE, 'parent');
            Navigator.pushNamedAndRemoveUntil(_context, '/login', (Route r) => false);
          } else if (userType == "teacher") {
            prefs.setString(USER_TYPE, 'teacher');
            Navigator.pushNamedAndRemoveUntil(_context, '/login', (Route r) => false);
          }
      });
    });
  }

  setContext(BuildContext context) {
    _context = context;
  }

  loadSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void signOut() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut().then((done) {
      Navigator.pushNamedAndRemoveUntil(_context, '/login', (Route r) => false);
      prefs.setString(USER_TYPE, "");
      prefs.setString(USER_NAME, "");
      prefs.setString(USER_CLASS, "");
    });
  }

  dispose() {
    _email.close();
    _password.close();
  }
}