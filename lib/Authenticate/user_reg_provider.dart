import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:medication_history_tracker/constants/app_constants.dart';
import 'package:medication_history_tracker/models/userdata.dart';

class UserRegProvider extends ChangeNotifier {
  Client client = Client();
  late Account _account;
  late bool _isloading;
  late bool _isloggedin;
  late bool _signedin;
  User? _user;

  bool get isloading => _isloading;
  bool get isloggedin => _isloggedin;
  bool get signedin => _signedin;
  User? get user => _user;

  UserRegProvider() {
    _isloading = true;
    _isloggedin = false;
    _signedin = false;
    _user = null;
    initializeclass();
  }

  initializeclass() {
    client
      ..setEndpoint(Appconstants.endpoint)
      ..setProject(Appconstants.projectid);
    _account = Account(client);
    _checksignin();
  }

  // check if there is an existing user
  _checksignin() async {
    try {
      _user = await _getUseraccount();
      notifyListeners();
    } catch (e) {
      _isloggedin = false;
      _isloading = false;
      // print("hello");
      notifyListeners();
    }
  }

  // map user details to the model class created earlier
  Future<User?> _getUseraccount() async {
    try {
      final response = await _account.get();
      if (response.status == true) {
        final jsondata = jsonEncode(response.toMap());
        final json = jsonDecode(jsondata);
        // print(json);
        _isloggedin = true;
        _isloading = false;
        return User.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      // print("get user: hello");
      rethrow;
    }
  }

  // login method
  login(String email, String password) async {
    try {
      final result = await _account.createEmailSession(
          email: email,
          password:
              password); // create a new email session with respect to the parameters provided (if an account exist, then we will be able to create a new session)
      _isloading = true;
      notifyListeners();
      if (result.userId.isNotEmpty) {
        _user = await _getUseraccount();
        _isloading = false;
        _isloggedin = true;
        notifyListeners();
        // print("login provider: ${_isloggedin}");
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // sign up method
  signup(String name, String email, String password) async {
    try {
      final result = await _account.create(
          userId: 'unique()',
          name: name,
          email: email,
          password:
              password); // create a new account with respect to the parameters given
      _isloading = true;
      notifyListeners();
      if (result.status == true) {
        _signedin = true;
        _isloading = false;
        // print(" signup provider: ${_isloggedin}");
        // checks of the status of the create account command is true or false.if it is true, it will set the _createaccount boolean to true and if it false, it will return the _getaccount function
        // _signedin = true;
        // _checklogin();
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // signout method
  signout() async {
    try {
      await _account.deleteSession(
          sessionId: 'current'); // delete the current logged in user session
      _isloggedin =
          false; // sets _isLoggedin to false thus the page won't automatically be logged in when re initialised
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}