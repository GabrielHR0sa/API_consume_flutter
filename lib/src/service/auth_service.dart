import 'dart:async';
import 'dart:convert';

import 'package:crud_local/src/models/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final dio = Dio();
  var _model = AuthModel();
  int? result = 0;
  var token;
  var gettoken;
  var correttoken;
  var incorrect = Text('');
  var passw = '';
  var confirm = false;

  Future<void> setUser(String value) async {
    _model = AuthModel(user: value, pass: _model.pass);
  }

  void setPass(String value) {
    _model = AuthModel(pass: value, user: _model.user);
  }

  void getPass() {
    passw = _model.pass;

    if (passw == '11203113') {
      confirm = true;
    } else {
      confirm = false;
    }

    notifyListeners();
  }

  Future<void> login() async {
    var user = _model.user;
    var pass = _model.pass;

    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    final IpConf = _sharedPreferences.getString('IP');
    String IP = '$IpConf';

    try {
      var response = await dio.post(
        'http://$IP/login',
        data: {'user': user, 'pass': pass},
      ).timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        result = response.statusCode;
        token = response.data;
        gettoken = await json.decode(json.encode(token['access']));
        await _sharedPreferences.setString('token', gettoken);
        correttoken = await _sharedPreferences.getString('token');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.message);
        print(e.response!.statusCode);
      }
      incorrect = const Text(
        'Usuário ou senha inválidos!',
        style: TextStyle(color: Colors.redAccent),
      );
    } on TimeoutException {
      incorrect = const Text(
        'Verifique o IP e tente novamente',
        style: TextStyle(color: Colors.redAccent),
      );
    }

    notifyListeners();
  }
}
