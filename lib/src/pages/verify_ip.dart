// ignore_for_file: must_call_super, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:async';

import 'package:crud_local/src/pages/auth/auth.dart';
import 'package:crud_local/src/pages/config/warning.dart';
import 'package:crud_local/src/pages/rejection/home_page.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyIp extends StatefulWidget {
  const VerifyIp({super.key});

  @override
  State<VerifyIp> createState() => _VerifyIpState();
}

final service = ErrorService();

class _VerifyIpState extends State<VerifyIp> {
  @override
  void initState() {
    _testIp();
    Timer(Duration(seconds: 2), () {
      tryIp().then((ip) async {
        if (ip == true) {
          tryToken().then((token) async {
            if (token == true) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            } else {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AuthPage()));
            }
          });
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => WarningPage()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: altura * 1,
        width: largura * 1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 16, 62, 100),
                Color.fromARGB(255, 80, 153, 212),
              ]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/images/nf.png')),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 50,
                width: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  colors: [Colors.white],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: const Text(
                  'Carregando...',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> tryIp() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    await service.Ping();

    if (service.resultpi == false) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> tryToken() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    if (_sharedPreferences.getString('token') == null) {
      return false;
    } else {
      return true;
    }
  }
}

_initialIP() async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

  var IP = _sharedPreferences.setString('IP', '164.163.52.232:62000');
  final teste = await _sharedPreferences.getString('IP');
  print('INIT: $teste');
  return teste;
}

_newIP() async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  final teste = await _sharedPreferences.getString('IP');
  print('NEW: $teste');
  return teste;
}

_testIp() async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

  if (await _sharedPreferences.getString('IP') == "" ||
      await _sharedPreferences.getString('IP') == null) {
    _initialIP();
  } else {
    _newIP();
  }
}
