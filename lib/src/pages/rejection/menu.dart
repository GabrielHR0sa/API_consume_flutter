import 'package:crud_local/src/service/auth_service.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final auth = AuthService();
  final service = ErrorService();
  Map<String, dynamic> data = {};

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
                  colors: <Color>[
                    Color.fromARGB(255, 16, 62, 100),
                    Color.fromARGB(255, 37, 81, 117),
                    Color.fromARGB(255, 66, 117, 158),
                    Color.fromARGB(255, 80, 153, 212),
                  ]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem Vindo!',
                        style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        'The Master Informática',
                        style: GoogleFonts.ubuntu(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 18,
                        ),
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(
                              color: const Color.fromARGB(255, 161, 161, 161),
                              curve: Curves.easeInOut,
                              duration: 2000.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              'Início',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'Configuração',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () {
              Navigator.of(context).popAndPushNamed('/askPass');
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_sync_outlined),
            title: Text(
              'Testar API',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () {
              setState(() {
                service.Ping();
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
              ).then((confirmed) async {
                if (confirmed) {
                  await service.Ping();
                  if (service.resultpi == true) {
                    Navigator.of(context).popAndPushNamed('/auth');
                  } else {
                    Navigator.of(context).popAndPushNamed('/warning');
                  }
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
