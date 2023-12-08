import 'dart:async';
import 'dart:io';

import 'package:crud_local/src/pages/auth/auth.dart';
import 'package:crud_local/src/pages/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? timer;
  var logedT = false;
  late ThemeController themeController;
  bool _selected = false;

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
      _releaseToken();
      super.dispose();
    }

    print(_selected);
  }

  _releaseToken() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;
    final menu = const Menu();

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
                  text: const TextSpan(children: [
                    TextSpan(
                        text: 'Sair',
                        style: TextStyle(fontSize: 22, color: Colors.black)),
                    TextSpan(text: '\n'),
                    TextSpan(
                        text: 'Deseja sair do App?',
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
          actions: [
            Container(
              margin: EdgeInsets.only(right: 30),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selected = !_selected;
                      print(_selected);
                      if (_selected == false) {
                        ThemeController.of(context).setTheme('light');
                      } else {
                        ThemeController.of(context).setTheme('dark');
                      }
                    });
                  },
                  child: _selected
                      ? const Icon(
                          CupertinoIcons.lightbulb,
                          color: Colors.white,
                          size: 35,
                        )
                      : const Icon(
                          CupertinoIcons.lightbulb_fill,
                          color: Colors.black,
                          size: 35,
                        )),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: altura * 0.15,
              width: largura * 1,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  Navigator.of(context).pushNamed('/addErr');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.add,
                      size: 50,
                    ),
                    Text(
                      'Adicionar rejeição',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: altura * 0.15,
              width: largura * 1,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  Navigator.of(context).pushNamed('/listFilErr');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.list_alt,
                      size: 50,
                    ),
                    Text(
                      'Listar rejeição',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeController extends ChangeNotifier {
  static const themePrefKey = 'theme';

  ThemeController(this._prefs) {
    // load theme from preferences on initialization
    _currentTheme = _prefs.getString(themePrefKey) ?? 'light';
  }

  final SharedPreferences _prefs;
  late String _currentTheme;

  /// get the current theme
  String get currentTheme => _currentTheme;

  void setTheme(String theme) {
    _currentTheme = theme;

    // notify the app that the theme was changed
    notifyListeners();

    // store updated theme on disk
    _prefs.setString(themePrefKey, theme);
  }

  /// get the controller from any page of your app
  static ThemeController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ThemeControllerProvider>()
            as ThemeControllerProvider;
    return provider.controller;
  }
}

/// provides the theme controller to any page of your app
class ThemeControllerProvider extends InheritedWidget {
  const ThemeControllerProvider(
      {Key? key, required this.controller, required Widget child})
      : super(key: key, child: child);

  final ThemeController controller;

  @override
  bool updateShouldNotify(ThemeControllerProvider old) =>
      controller != old.controller;
}
