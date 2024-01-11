import 'package:crud_local/src/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  var headers = {'content-type': 'application/json'};
  var _model = UserModel();
  var dio = Dio();

  void setNomUsu(String value) {
    _model = UserModel(
      nomusu: value,
      logusu: _model.logusu,
      senusu: _model.senusu,
    );
  }

  void setLogUsu(String value) {
    _model = UserModel(
      logusu: value,
      nomusu: _model.nomusu,
      senusu: _model.senusu,
    );
  }

  void setSenUsu(String value) {
    _model = UserModel(
      senusu: value,
      logusu: _model.logusu,
      nomusu: _model.nomusu,
    );
  }

  void setCodUsu(int value) {
    _model = UserModel(
      codusu: value,
      logusu: _model.logusu,
      nomusu: _model.nomusu,
      senusu: _model.senusu,
    );
  }

  catchUser() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final token = await _sharedPreferences.getString('token');
    final IpConfig = await _sharedPreferences.getString('IP');
    String IP = '$IpConfig';

    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    var response = await http
        .get(Uri.parse('http://$IP/user/crud?logusu=termas'), headers: headers);

    print(response.body);
    return response;
  }
}
