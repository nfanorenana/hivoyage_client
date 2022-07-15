import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hivoyage/domain/user.dart';
import 'package:hivoyage/util/app_url.dart';
import 'package:hivoyage/util/storage.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    Map<String, dynamic> result;

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(AppUrl.login),
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData['user'];

      User authUser = User.fromJson(userData);
      authUser.token = responseData['access_token'];
      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {
        'status': true,
        'message': 'Succès',
        'user': authUser,
      };
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
      String name, String username, String email, String password) async {
    Map<String, dynamic> result;

    _registeredInStatus = Status.Registering;
    notifyListeners();

    Response response = await post(
      Uri.parse(AppUrl.register),
      body: {
        'customer_name': name,
        'username': username,
        'email': email,
        'password': password
      },
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData['user'];

      User authUser = User.fromJson(userData);
      authUser.token = responseData['access_token'];
      UserPreferences().saveUser(authUser);

      _registeredInStatus = Status.Registered;
      notifyListeners();

      result = {
        'status': true,
        'message': 'Succès',
        'user': authUser,
      };
    } else {
      _registeredInStatus = Status.NotRegistered;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> logout() async {
    String token = await UserPreferences().getToken();
    Response response = await post(
      Uri.parse(AppUrl.logout),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      UserPreferences().removeUser();
      return {
        'status': true,
        'message': json.decode(response.body)['message'],
      };
    } else {
      return {
        'status': false,
        'message': 'Une erreur s\'est produite. Veuillez réessayer plus tard',
      };
    }
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    print(response.statusCode);
    if (response.statusCode == 200) {
      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
//      if (response.statusCode == 401) Get.toNamed("/login");
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
