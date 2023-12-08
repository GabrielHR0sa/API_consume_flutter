import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crud_local/src/pages/auth/auth.dart';
import 'package:crud_local/src/pages/config/config.dart';
import 'package:crud_local/src/pages/config/config_auth.dart';
import 'package:crud_local/src/pages/config/password.dart';
import 'package:crud_local/src/pages/config/password_auth.dart';
import 'package:crud_local/src/pages/error/add.dart';
import 'package:crud_local/src/pages/error/edit.dart';
import 'package:crud_local/src/pages/error/list_filtro.dart';
import 'package:crud_local/src/pages/home_page.dart';
import 'package:crud_local/src/pages/verify_ip.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  await _sharedPreferences.remove('token');

  final themeController = ThemeController(_sharedPreferences);
  runApp(
    MyApp(themeController: themeController),
  );
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  const MyApp({
    Key? key,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return ThemeControllerProvider(
          controller: themeController,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: _buildCurrentTheme(),
            initialRoute: ('/verifyIp'),
            routes: {
              ('/auth'): (context) => AuthPage(),
              ('/config'): (context) => const ConfigPage(),
              ('/configAuth'): (context) => const ConfigAuthPage(),
              ('/addErr'): (context) => const AddError(),
              ('/listFilErr'): (context) => const ListFiltErros(),
              ('/editErr'): (context) => EditErr(),
              ('/askPass'): (context) => const AskPassword(),
              ('/askAuthPass'): (context) => const AskAuthPassword(),
              ('/verifyIp'): (context) => const VerifyIp(),
              ('/'): (context) => const HomePage(),
            },
          ),
        );
      },
    );
  }

  ThemeData _buildCurrentTheme() {
    switch (themeController.currentTheme) {
      case "dark":
        return ThemeData(
          textTheme: TextTheme(
            bodyMedium: const TextStyle(color: Colors.white, fontSize: 22),
            bodyLarge:
                TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 20),
            titleLarge: const TextStyle(color: Colors.white),
            bodySmall: const TextStyle(
              color: Color.fromARGB(255, 39, 39, 39),
            ),
          ),
          colorScheme: const ColorScheme.dark(
              brightness: Brightness.dark,
              primary: Colors.white,
              onPrimary: Colors.black,
              secondary: Colors.black,
              onSecondary: Colors.white,
              error: Colors.black,
              onError: Colors.black,
              background: Color.fromARGB(255, 75, 75, 75),
              onBackground: Colors.white,
              surface: Color.fromARGB(255, 39, 39, 39),
              onSurface: Colors.white),
        );
      case "light":
      default:
        return ThemeData(
          textTheme: TextTheme(
            bodyMedium: const TextStyle(color: Colors.black, fontSize: 22),
            bodyLarge:
                TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 20),
            titleLarge: const TextStyle(color: Colors.black),
            bodySmall: const TextStyle(color: Colors.white),
          ),
          colorScheme: const ColorScheme.light(
              brightness: Brightness.light,
              primary: Colors.black,
              onPrimary: Colors.white,
              secondary: Colors.white,
              onSecondary: Colors.white,
              error: Colors.white,
              onError: Colors.white,
              background: Color.fromARGB(255, 196, 196, 196),
              onBackground: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black),
        );
    }
  }
}
