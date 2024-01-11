import 'package:crud_local/src/service/auth_service.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class MenuUser extends StatefulWidget {
  const MenuUser({super.key});

  @override
  State<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  final auth = AuthService();
  final service = ErrorService();
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();

    service.addListener(() {
      if (service.resultpi == true) {
        dialogs.success(context, 'Sucesso', 'API rodando');
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
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color.fromARGB(255, 16, 62, 100),
                    Color.fromARGB(255, 37, 81, 117),
                    Color.fromARGB(255, 66, 117, 158),
                    Color.fromARGB(255, 80, 153, 212),
                  ]),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem Vindo!',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
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
                service.Ping();
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
