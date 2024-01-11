import 'dart:async';
import 'dart:io';

import 'package:crud_local/src/pages/auth/auth.dart';
import 'package:crud_local/src/pages/responsive_config.dart';
import 'package:crud_local/src/pages/user/menu_user.dart';
import 'package:crud_local/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  Timer? timer;
  var logedT = false;
  final auth = AuthService();

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(minutes: 15), () {
      setState(() {
        logedT = true;
      });
    });

    @override
    void dispose() {
      timer!.cancel();
      _releasePrefs();
      super.dispose();
    }
  }

  _releasePrefs() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.remove('token');
    await _sharedPreferences.remove('logUser');
    await _sharedPreferences.remove('subToken');
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;
    final menu = const MenuUser();
    final isMob = isMobile(context);

    if (logedT == true) {
      print('Sessão expirou');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AuthPage()));

        logedT = false;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Sair',
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextSpan(text: '\n'),
                    TextSpan(
                        text: 'Deseja sair do App?',
                        style: Theme.of(context).textTheme.bodyLarge),
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
          drawer: menu,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/images/nf.png')),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'NFe Error',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              if (isMob)
                Center(
                  child: Container(
                    height: altura * 0.15,
                    width: 500,
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/getSolution');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.search,
                            size: 50,
                          ),
                          Text(
                            'Buscar Solução',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Container(
                  height: altura * 0.15,
                  width: largura * 1,
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/getSolution');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.search,
                          size: 50,
                        ),
                        Text(
                          'Buscar Solução',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          )),
    );
  }
}
