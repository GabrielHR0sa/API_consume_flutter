import 'package:crud_local/src/service/auth_service.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final auth = AuthService();
  final service = ErrorService();

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
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromARGB(255, 119, 159, 192),
                    Color.fromARGB(255, 26, 88, 139),
                  ])),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(children: [
                        TextSpan(
                          text: 'Bem Vindo!',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ])),
                ),
              )),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuração'),
            onTap: () {
              Navigator.of(context).popAndPushNamed('/askPass');
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_sync_outlined),
            title: const Text('Testar API'),
            onTap: () {
              setState(() {
                //service.tryPingSo();
                service.tryPings();
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              showDialog(
                context: context,
                builder: ((context) => AlertDialog(
                      title: const Text('Log out'),
                      content: const Text('Deseja fazer o logout?'),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('Não'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Sim'),
                        ),
                      ],
                    )),
              ).then((confirmed) {
                if (confirmed) {
                  Navigator.of(context).popAndPushNamed('/auth');
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
