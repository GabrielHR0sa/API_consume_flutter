import 'dart:async';
import 'dart:io';

import 'package:crud_local/src/pages/auth/auth.dart';
import 'package:crud_local/src/pages/rejection/menu.dart';
import 'package:crud_local/src/pages/responsive_config.dart';
import 'package:crud_local/src/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool _selected = false;

_readSelect() async {
/*
  função para salvar o estado do icone que troca o tema
  toda vez que o aplicativo inicia, seu valor é igual ao 
  valor do tema em questão. Sem ele o botão inicia false sempre,
  mesmo seu tema sendo outro.
*/

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? message = await prefs.getBool('select');

  if (message == false) {
    _selected = false;
  } else if (message == true) {
    _selected = true;
  } else {
    _selected = false;
  }
}

class _HomePageState extends State<HomePage> {
  Timer? timer;
  var logedT = false;
  late ThemeController themeController;
  final auth = AuthService();

  @override
  void initState() {
    super.initState();

    /*
      inicia o contador assim que o app é aberto,
      ao final do contador, logeT = true, o que
      faz com que o app seja fechado passando
      como sessão expirada.
     */
    timer = Timer(const Duration(minutes: 15), () {
      setState(() {
        logedT = true;
      });
    });

    _readSelect();

    @override
    void dispose() {
      timer!.cancel();
      _releasePrefs();
      super.dispose();
    }
  }

  _releasePrefs() async {
    /*
      função para eliminar as preferências ao sair do app,
      para não carregar a memória e permitir alterações
      entre usuário master e comum
     */

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
    final menu = const Menu();

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
          actions: [
            Container(
              margin: EdgeInsets.only(right: 30),
              child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    setState(() {
                      _selected = !_selected;
                      if (_selected == false) {
                        ThemeController.of(context).setTheme('light');
                        prefs.setBool('select', false);
                      } else {
                        ThemeController.of(context).setTheme('dark');
                        prefs.setBool('select', true);
                      }
                    });
                  },
                  child: _selected
                      ? const Icon(
                          CupertinoIcons.lightbulb_slash_fill,
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
            if (isMob)
              Center(
                child: Container(
                  height: altura * 0.15,
                  width: 500,
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
                      Navigator.of(context).pushNamed('/addErr');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.add,
                          size: 50,
                        ),
                        Text(
                          'Adicionar rejeição',
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic),
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
                    Navigator.of(context).pushNamed('/addErr');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.add,
                        size: 50,
                      ),
                      Text(
                        'Adicionar rejeição',
                        style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            if (isMob)
              Center(
                child: Container(
                  height: altura * 0.15,
                  width: 500,
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
                      Navigator.of(context).pushNamed('/listFilErr');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.list_alt,
                          size: 50,
                        ),
                        Text(
                          'Listar rejeição',
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic),
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
                    Navigator.of(context).pushNamed('/listFilErr');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.list_alt,
                        size: 50,
                      ),
                      Text(
                        'Listar rejeição',
                        style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class ThemeController extends ChangeNotifier {
  static const themePrefKey = 'theme';

  ThemeController(this._prefs) {
    // carrega a preferência do tema na inicialização
    _currentTheme = _prefs.getString(themePrefKey) ?? 'light';
  }

  final SharedPreferences _prefs;
  late String _currentTheme;

  // pega o tema atual
  String get currentTheme => _currentTheme;

  void setTheme(String theme) {
    _currentTheme = theme;

    // avisa o app que o tema mudou
    notifyListeners();

    // salva o novo tema na memória
    _prefs.setString(themePrefKey, theme);
  }

  // pega o controle de tema de qualquer parte do código
  static ThemeController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ThemeControllerProvider>()
            as ThemeControllerProvider;
    return provider.controller;
  }
}

// provê o controle de tema de qualquer parte do código
class ThemeControllerProvider extends InheritedWidget {
  const ThemeControllerProvider(
      {Key? key, required this.controller, required Widget child})
      : super(key: key, child: child);

  final ThemeController controller;

  @override
  bool updateShouldNotify(ThemeControllerProvider old) =>
      controller != old.controller;
}
