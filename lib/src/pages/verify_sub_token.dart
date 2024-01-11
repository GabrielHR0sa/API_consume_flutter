import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _master = false;

class VerifySubToken extends StatefulWidget {
  const VerifySubToken({super.key});

  @override
  State<VerifySubToken> createState() => _VerifySubTokenState();
}

class _VerifySubTokenState extends State<VerifySubToken> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      trySub().then((ip) async {
        if (_master == true) {
          Navigator.of(context).popAndPushNamed('/');
        } else {
          Navigator.of(context).popAndPushNamed('/user');
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

  trySub() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? logedToken = await prefs.getString('subToken');
    if (logedToken == "0") {
      _master = true;
    } else {
      _master = false;
    }
  }
}
