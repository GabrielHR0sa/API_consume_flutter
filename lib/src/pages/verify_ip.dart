import 'dart:async';

import 'package:crud_local/src/pages/auth/auth.dart';
import 'package:crud_local/src/pages/config/config_auth.dart';
import 'package:crud_local/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyIp extends StatefulWidget {
  const VerifyIp({super.key});

  @override
  State<VerifyIp> createState() => _VerifyIpState();
}

class _VerifyIpState extends State<VerifyIp> {
  @override
  void initState() {
    super.initState();
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
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ConfigAuthPage()));
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
              const CircularProgressIndicator(
                color: Colors.white,
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

    if (_sharedPreferences.getString('IP') == null) {
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

  Future<bool> tryIni() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    if (_sharedPreferences.getString('onIni') == false) {
      return false;
    } else {
      return true;
    }
  }
}
