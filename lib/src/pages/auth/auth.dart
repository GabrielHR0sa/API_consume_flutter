import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:crud_local/src/pages/home_page.dart';
import 'package:crud_local/src/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  AuthPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final service = AuthService();
  bool viewPass = false;

  @override
  void initState() {
    super.initState();
    service.addListener(() {
      setState(() {
        if (service.result == 200) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      });
    });
    viewPass = false;
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(children: [
                    TextSpan(
                        text: 'Sair',
                        style: TextStyle(fontSize: 22, color: Colors.black)),
                    TextSpan(text: '\n'),
                    TextSpan(
                        text: 'Deseja Sair do Aplicativo?',
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                  ])),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Não'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences _sharedPreferences =
                        await SharedPreferences.getInstance();
                    await _sharedPreferences.remove('token');
                    exit(0);
                  },
                  child: const Text('Sim'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Material(
        color: const Color.fromARGB(255, 80, 153, 212),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: altura * 0.4,
              width: double.infinity,
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
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    const TextSpan(
                      text: 'NFe Error',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                    const TextSpan(
                      text: ' \n ',
                    ),
                    TextSpan(
                      text: 'by Gabriel Rosa',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 12),
                    ),
                  ]),
                ),
              ),
            ),
            Container(
              height: altura * 0.6,
              decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    child: Center(
                      child: AnimatedBuilder(
                          animation: service,
                          builder: (context, child) {
                            return service.incorrect;
                          }),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      onChanged: service.setUser,
                      decoration: const InputDecoration(
                        labelText: 'Usuário',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      onChanged: service.setPass,
                      obscureText: !viewPass,
                      decoration: InputDecoration(
                          labelText: 'Senha',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  viewPass = !viewPass;
                                });
                              },
                              icon: Icon(viewPass
                                  ? CupertinoIcons.eye
                                  : CupertinoIcons.eye_slash))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: altura * 0.06,
                    width: largura * 1,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/');
                        //service.login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 16, 62, 100),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 30,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).popAndPushNamed('/askAuthPass');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.settings),
                            Text('config'),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
