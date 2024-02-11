import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_keys/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassw =>
      _passwController.stream.transform(validatePassw);
  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid =>
      Rx.combineLatest2(outEmail, outPassw, (a, b) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassw => _passwController.sink.add;

  late StreamSubscription<User?> _streamSubscription;

  LoginBloc() {
    _streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        if (await verifyPrivileges(event)) {
          _stateController.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    _stateController.add(LoginState.IDLE);
  }

  void submit() {
    final email = _emailController.value;
    final password = _passwController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _stateController.add(LoginState.FAIL);
    });
  }

  Future<bool> verifyPrivileges(User user) async {
    return await FirebaseFirestore.instance
        .collection("admin")
        .doc(user.uid)
        .get()
        .then((doc) {
      return true;
    }).catchError((e) {
      return false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.close();
    _passwController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }
}
