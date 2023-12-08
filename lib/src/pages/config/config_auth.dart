import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigAuthPage extends StatefulWidget {
  const ConfigAuthPage({super.key});

  @override
  State<ConfigAuthPage> createState() => _ConfigAuthPageState();
}

TextEditingController _ipInputController = TextEditingController();
TextEditingController _portInputController = TextEditingController();
final service = ErrorService();

class _ConfigAuthPageState extends State<ConfigAuthPage> {
  @override
  void initState() {
    super.initState();
    service.addListener(() {
      if (service.resultpi == true) {
        dialogs.success(
            context, 'Sucesso', 'Api GetSolution: On \n Api Auth: On');
      } else {
        dialogs.error(
            context, 'Erro', 'Erro ao conectar-se a API, verifique o ip');
      }
    });

    _ValidateIp();
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuração Auth'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/auth');
          },
          icon: const Icon(
            Icons.arrow_circle_left,
            size: 30,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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

                    _saveIP().then((Ip) async {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'IP Salvo!',
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ));
                    });
                  },
                  child: const Text(
                    'Salvar',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          service.tryPings();
                        });
                      },
                      child: const Text(
                        'Testar Ip',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _saveIP() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    var IP = _sharedPreferences.setString('IP', _ipInputController.text);
    if (IP == '') {
      dialogs.information(context, 'Erro', 'Ip inválido');
      return false;
    } else {
      return true;
    }
  }

  _ValidateIp() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    if (_sharedPreferences.getString('IP') != null) {
      var label = await _sharedPreferences.getString('IP');
      _ipInputController.text = '$label';
    }
  }
}
