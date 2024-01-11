import 'dart:io';

import 'package:crud_local/src/pages/responsive_config.dart';
import 'package:crud_local/src/pages/verify_sub_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:crud_local/src/service/auth_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
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
              MaterialPageRoute(builder: (context) => const VerifySubToken()));
        }
      });
    });
    viewPass = false;
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;

    final isMob = isMobile(context);

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
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                      colors: <Color>[
                        Color.fromARGB(255, 16, 62, 100),
                        Color.fromARGB(255, 37, 81, 117),
                        Color.fromARGB(255, 66, 117, 158),
                        Color.fromARGB(255, 80, 153, 212),
                      ]),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'NFe Error',
                        style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 37,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      const TextSpan(
                        text: ' \n ',
                      ),
                      TextSpan(
                        text: 'by TMI informática',
                        style: GoogleFonts.ubuntu(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                          color: const Color.fromARGB(255, 161, 161, 161),
                          curve: Curves.easeInOut,
                          duration: 2000.ms),
                ),
              ),
              if (isMob)
                Container(
                  height: altura * 0.6,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
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
                        width: 400,
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
                        width: 400,
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
                        width: largura * 0.2,
                        margin: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () {
                            service.login();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 16, 62, 100),
                            side: const BorderSide(
                                width: 3, color: Colors.transparent),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  height: altura * 0.6,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
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
                        margin: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () {
                            service.login();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 16, 62, 100),
                            side: const BorderSide(
                                width: 3, color: Colors.transparent),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
