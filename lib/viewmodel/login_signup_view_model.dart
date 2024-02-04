import 'dart:io';

import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utils/routes/routes_names.dart';

class LoginSignUpViewModel with ChangeNotifier {
  bool _isLogin = true;
  String _varificationCode = '';
  String _phoneNumber = '';
  String _userName = '';
  File? _userImage;
  ConfirmationResult? confirmationResult;

  bool _isAutheticating = false;
  bool _isVerifying = false;

  bool get isLogin => _isLogin;
  String get phoneNumber => _phoneNumber;
  String get varificationCode => _varificationCode;
  String get userName => _userName;
  File? get userImage => _userImage;

  bool get isAutheticating => _isAutheticating;
  bool get isVerifying => _isVerifying;
  final _firebase = FirebaseAuth.instance;

  void setIsLogIn(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  void setVarificationCode(String value) {
    _varificationCode = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setUserName(String value) {
    _userName = value;
    notifyListeners();
  }

  void setUserImage(File value) {
    _userImage = value;
    notifyListeners();
  }

  void onSignUpWithEmail(BuildContext context) {
    _isLogin = false;
    notifyListeners();
    Navigator.pushNamed(context, RoutesNames.loginScreen);
  }

  void onLogin(BuildContext context) {
    _isLogin = true;
    notifyListeners();
    Navigator.pushNamed(context, RoutesNames.loginScreen);
  }

  void signUpWithPhoneNumber(
    BuildContext context,
    String smsCode,
    void Function() onNavigate,
  ) async {
    _isVerifying = true;
    notifyListeners();

    final credentials = PhoneAuthProvider.credential(
        verificationId: varificationCode, smsCode: smsCode);
    try {
      final userCredentials = await _firebase.signInWithCredential(credentials);

      final storgeRef = FirebaseStorage.instance
          .ref()
          .child("users_image")
          .child('${userCredentials.user!.uid}.jpg');

      await storgeRef.putFile(userImage!);
      final imageUrl = await storgeRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set(
        {
          'username': userName,
          'number': phoneNumber,
          'image_url': imageUrl,
        },
      );

      onNavigate();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      MyUtils().showToast(context, error.code);
      _isVerifying = false;
      notifyListeners();
    }
  }

  void requestForNumberVerification(
    BuildContext context,
    void Function() onNavigate,
  ) async {
    _isAutheticating = true;
    notifyListeners();
    await _firebase.verifyPhoneNumber(
      phoneNumber: '+$phoneNumber',
      verificationCompleted: (e) {
        MyUtils().showToast(context, 'Succefuly varified');
        _isAutheticating = false;
        notifyListeners();
      },
      verificationFailed: (e) {
        MyUtils().showToast(context, 'Varification faild');
        _isAutheticating = false;
        notifyListeners();
      },
      codeSent: (String varificationId, int? token) {
        setVarificationCode(varificationId);
        onNavigate();
      },
      codeAutoRetrievalTimeout: (e) {},
    );
  }

  void loginWithNumber(
      BuildContext context, String smsCode, void Function() onNavigate) async {
    try {
      _isVerifying = true;
      notifyListeners();
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: varificationCode,
        smsCode: smsCode, // replace with the code sent to the user's phone
      );

      await _firebase.signInWithCredential(credential);
      onNavigate();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      MyUtils().showToast(context, error.code);
      _isVerifying = false;
      notifyListeners();
    }
  }
}
