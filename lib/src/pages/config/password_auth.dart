import 'package:crud_local/src/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AskAuthPassword extends StatefulWidget {
  const AskAuthPassword({super.key});

  @override
  State<AskAuthPassword> createState() => _AskAuthPasswordState();
}

class _AskAuthPasswordState extends State<AskAuthPassword> {
  final service = AuthService();
  bool viewPass = false;
  Widget resposta = Container();

  @override
  void initState() {
    super.initState();
    service.addListener(() {
      setState(() {
        if (service.result == 200) {
          Navigator.of(context).pop('/');
        }
      });
    });
    viewPass = false;
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;

    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_circle_left,
                        size: 30,
                      ),
                    ),
                    const Text('Voltar'),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: altura * 0.4,
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: resposta,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
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
                          service.getPass();
                          if (service.confirm == true) {
                            Navigator.of(context).pushNamed('/configAuth');
                          } else {
                            resposta = Container(
                              child: const Text(
                                'Senha incorreta',
                                style:
                                    TextStyle(fontSize: 10, color: Colors.red),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Confirmar',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
