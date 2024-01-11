// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:crud_local/src/pages/responsive_config.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

TextEditingController _ipInputController = TextEditingController();
TextEditingController _portInputController = TextEditingController();
final service = ErrorService();
bool loading = false;
bool changeSt = false;
var newIP;
var saved = false;
bool _master = false;

class _ConfigPageState extends State<ConfigPage> {
  @override
  void initState() {
    super.initState();

    service.addListener(() {
      if (service.resultdb == true) {
        dialogs.success(
            context, 'Sucesso', 'Banco GetSolution: On \n Banco Auth: On');
        setState(() {
          loading = false;
        });
      } else if (service.resultdb == null) {
        dialogs.warning(context, 'Aviso', 'Salve o ip para poder testar');
        setState(() {
          loading = false;
        });
      } else {
        dialogs.error(
            context, 'Erro', 'Erro ao conectar-se ao Banco, verifique o ip');
        setState(() {
          loading = false;
        });
      }
    });
    _ValidateIp();
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;
    final isMob = isMobile(context);

    return WillPopScope(
      onWillPop: () async {
        if (saved == true) {
          await service.DB();
          if (service.resultdb == true) {
            Navigator.of(context).popAndPushNamed('/auth');
            return Future.value(false);
          } else {
            Navigator.of(context).popAndPushNamed('/warning');
            return Future.value(false);
          }
        } else {
          trySub().then((ip) async {
            if (_master == true) {
              Navigator.of(context).popAndPushNamed('/');
            } else {
              Navigator.of(context).popAndPushNamed('/user');
            }
          });
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurações'),
          leading: IconButton(
            onPressed: () async {
              setState(() {
                changeSt = true;
              });
              if (saved == true) {
                await service.DB();
                if (service.resultdb == true) {
                  saved = false;
                  changeSt = false;
                  Navigator.of(context).popAndPushNamed('/auth');
                  return Future.value(false);
                } else {
                  saved = false;
                  changeSt = false;
                  Navigator.of(context).popAndPushNamed('/warning');
                  return Future.value(false);
                }
              } else {
                trySub().then((ip) async {
                  if (_master == true) {
                    Navigator.of(context).popAndPushNamed('/');
                  } else {
                    Navigator.of(context).popAndPushNamed('/user');
                  }
                });
                return Future.value(false);
              }
            },
            icon: changeSt
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ))
                : const Icon(
                    Icons.arrow_circle_left,
                    size: 30,
                  ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isMob)
              Center(
                child: Container(
                  height: altura * 0.4,
                  width: 700,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'IP:Porta',
                          ),
                          controller: _ipInputController,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          SharedPreferences _sharedPreferences =
                              await SharedPreferences.getInstance();

                          saveIP().then((Ip) async {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'IP Salvo!',
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ));
                          });
                        },
                        child: Text(
                          'Salvar',
                          style:
                              GoogleFonts.openSans(fontStyle: FontStyle.italic),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          loading
                              ? const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.ballRotateChase,
                                    colors: [Colors.blue],
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      service.tryDbs(_ipInputController.text);
                                      loading = true;
                                    });
                                  },
                                  child: Text(
                                    'Testar Banco',
                                    style: GoogleFonts.openSans(
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            else
              Container(
                height: altura * 0.4,
                width: largura * 1,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'IP:Porta',
                        ),
                        controller: _ipInputController,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences _sharedPreferences =
                            await SharedPreferences.getInstance();

                        saveIP().then((Ip) async {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'IP Salvo!',
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ));
                        });
                      },
                      child: Text(
                        'Salvar',
                        style:
                            GoogleFonts.openSans(fontStyle: FontStyle.italic),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        loading
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballRotateChase,
                                  colors: [Colors.blue],
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    service.tryDbs(_ipInputController.text);
                                    loading = true;
                                  });
                                },
                                child: Text(
                                  'Testar Banco',
                                  style: GoogleFonts.openSans(
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  saveIP() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    var IP = _sharedPreferences.setString('IP', _ipInputController.text);
    newIP = _sharedPreferences.getString('IP');
    saved = true;
  }

  _ValidateIp() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    if (_sharedPreferences.getString('IP') != null) {
      var label = await _sharedPreferences.getString('IP');
      _ipInputController.text = '$label';
    }
  }

  /*
    verifica o sub do usuário para verificar na hora de voltar das configurações
  */
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
