// ignore_for_file: unused_local_variable, unnecessary_null_comparison

import 'dart:async';

import 'package:crud_local/src/models/error_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ErrorService extends ChangeNotifier {
  var headers = {'content-type': 'application/json'};
  final dio = Dio();
  var _model = ErrorModel();

  var result = 0;
  var content = '';
  var resultdb;
  var resultpi;
  var scode = 0;
  var filt = false;
  var cod = 0;
  var des = '';
  var sol = '';
  var teste = false;

  void setCodErr(String value) {
    _model = ErrorModel(
        coderr: int.tryParse(value) ?? 0,
        deserr: _model.deserr,
        solerr: _model.solerr);
  }

  void setDesErr(String value) {
    _model = ErrorModel(
      deserr: value,
      coderr: _model.coderr,
      solerr: _model.solerr,
    );
  }

  void setSolErr(String value) {
    _model = ErrorModel(
      solerr: value,
      coderr: _model.coderr,
      deserr: _model.deserr,
    );
  }

  getSolution(String TipoPes) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final token = await _sharedPreferences.getString('token');
    var IpConf = _sharedPreferences.getString('IP');
    String IP = '$IpConf';

    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    var response = await http.get(Uri.parse('http://$IP/buscasolucao$TipoPes'),
        headers: headers);
    print(response.statusCode);
    return response;
  }

  Future<void> addError() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final token = await _sharedPreferences.getString('token');
    var IpConf = _sharedPreferences.getString('IP');
    String IP = '$IpConf';

    cod = _model.coderr;
    des = _model.deserr!;
    sol = _model.solerr!;

    try {
      Response response;
      response = await dio.post('http://$IP/erro/crud',
          data: {'coderr': cod, 'deserr': des, 'solerr': sol},
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          }));
      result = 204;
      print(response.statusCode);
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.message);
        print(e.response!.statusCode);
      }
    }
    notifyListeners();
  }

  Future<void> updateError() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final token = await _sharedPreferences.getString('token');
    final cod = await _sharedPreferences.getString('id');
    var IpConf = _sharedPreferences.getString('IP');
    String IP = '$IpConf';
    final deser = _model.deserr;
    final soler = _model.solerr;

    try {
      Response response;

      if (deser != '' && soler != '') {
        //edição dos dois campos
        response = await dio.put('http://$IP/erro/crud/$cod',
            data: {"deserr": deser, "solerr": soler},
            options: Options(headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json"
            }));
        scode = response.statusCode!;
        print(response.statusCode);
        teste = true;
      } else if (deser == '' && soler != '') {
        //edição sem descrição
        response = await dio.put('http://$IP/erro/crud/$cod',
            data: {"solerr": soler},
            options: Options(headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json"
            }));
        scode = response.statusCode!;
        print(response.statusCode);
        teste = true;
      } else if (deser != '' && soler == '') {
        //edição sem solução
        response = await dio.put('http://$IP/erro/crud/$cod',
            data: {"deserr": deser},
            options: Options(headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json"
            }));
        scode = response.statusCode!;
        print(response.statusCode);
        teste = true;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.message);
        print(e.response!.statusCode);
      }
    }
    notifyListeners();
  }

  Future<void> deleteError() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final token = await _sharedPreferences.getString('token');
    final cod = await _sharedPreferences.getString('id');
    var IpConf = _sharedPreferences.getString('IP');
    String IP = '$IpConf';

    try {
      Response response;
      response = await dio.delete('http://$IP/erro/crud/$cod',
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          }));

      print(response.statusCode);
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.message);
        print(e.response!.statusCode);
      }
    }
    notifyListeners();
  }

  catchRejection(String TipoPes) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final token = await _sharedPreferences.getString('token');
    final IpConf = await _sharedPreferences.getString('IP');
    String IP = '$IpConf';
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    if (TipoPes == '') {
      //se filtro vazio, mostra todos
      var response =
          await http.get(Uri.parse('http://$IP/erro/crud'), headers: headers);

      print(response.statusCode);
      return response;
    } else if (TipoPes == '?deserr=null') {
      //se filtro nulo, mostra somente os nulos
      var response = await http
          .get(Uri.parse('http://$IP/erro/crud?deserr=null'), headers: headers);

      print(response.statusCode);
      return response;
    } else {
      var response = await http.get(Uri.parse('http://$IP/erro/crud$TipoPes'),
          headers: headers);

      print(response.statusCode);
      return response;
    }
  }

//------------------------------------------Auth-----------------------------------------------------------//

  /*
    tryPings e tryDbs recebem passagem de parâmetro para permitir que
    a verificação seja feita sem ter o ip salvo. recebendo o campo
    da configuração após o fim da escrita.

    Ping e DB somente realizam a verificação se o ip for salvo
  */

  Future<void> tryPings(String IP) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    try {
      if (IP == '' || IP == null) {
        resultpi = null;
      } else {
        var response = await Future.wait([
          dio.get('http://$IP/getsolution/ping').timeout(
                const Duration(seconds: 5),
              ),
          dio.get('http://$IP/auth/ping').timeout(
                const Duration(seconds: 5),
              ),
        ]);
        resultpi = true;
      }
    } on DioException {
      resultpi = false;
    } on TimeoutException {
      resultpi = false;
    }
    notifyListeners();
  }

  Future<void> tryDbs(String IP) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final token = _sharedPreferences.getString('token');

    try {
      if (IP == '' || IP == null) {
        resultdb = null;
      } else {
        var response = await Future.wait([
          dio
              .get('http://$IP/getsolution/testdb',
                  options: Options(headers: {
                    "Authorization": "Bearer $token",
                    "Content-Type": "application/json"
                  }))
              .timeout(
                const Duration(seconds: 5),
              ),
          dio
              .get('http://$IP/auth/testdb',
                  options: Options(headers: {
                    "Authorization": "Bearer $token",
                    "Content-Type": "application/json"
                  }))
              .timeout(
                const Duration(seconds: 5),
              ),
        ]);

        resultdb = true;
      }
    } on DioException {
      resultdb = false;
    } on TimeoutException {
      resultdb = false;
    }
    notifyListeners();
  }

  Future<void> Ping() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final IpConf = await _sharedPreferences.getString('IP');
    String IP = '$IpConf';

    try {
      if (IP == '' || IP == null) {
        resultpi = null;
      } else {
        var response = await Future.wait([
          dio.get('http://$IP/getsolution/ping').timeout(
                const Duration(seconds: 5),
              ),
          dio.get('http://$IP/auth/ping').timeout(
                const Duration(seconds: 5),
              ),
        ]);
        resultpi = true;
      }
    } on DioException {
      resultpi = false;
    } on TimeoutException {
      resultpi = false;
    }
    notifyListeners();
  }

  Future<void> DB() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final token = _sharedPreferences.getString('token');
    final IpConf = await _sharedPreferences.getString('IP');
    String IP = '$IpConf';

    try {
      if (IP == '' || IP == null) {
        resultdb = null;
      } else {
        var response = await Future.wait([
          dio
              .get('http://$IP/getsolution/testdb',
                  options: Options(headers: {
                    "Authorization": "Bearer $token",
                    "Content-Type": "application/json"
                  }))
              .timeout(
                const Duration(seconds: 5),
              ),
          dio
              .get('http://$IP/auth/testdb',
                  options: Options(headers: {
                    "Authorization": "Bearer $token",
                    "Content-Type": "application/json"
                  }))
              .timeout(
                const Duration(seconds: 5),
              ),
        ]);

        resultdb = true;
      }
    } on DioException {
      resultdb = false;
    } on TimeoutException {
      resultdb = false;
    }
    notifyListeners();
  }
}
