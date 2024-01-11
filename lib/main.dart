import 'package:crud_local/src/pages/config/config_auth.dart';
import 'package:crud_local/src/pages/rejection/add.dart';
import 'package:crud_local/src/pages/rejection/edit.dart';
import 'package:crud_local/src/pages/user/get_solution.dart';
import 'package:crud_local/src/pages/user/home_user_page.dart';
import 'package:crud_local/src/pages/verify_sub_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crud_local/src/pages/auth/auth.dart';
import 'package:crud_local/src/pages/config/config.dart';
import 'package:crud_local/src/pages/config/warning.dart';
import 'package:crud_local/src/pages/config/password.dart';
import 'package:crud_local/src/pages/config/password_auth.dart';
import 'package:crud_local/src/pages/rejection/list_filtro.dart';
import 'package:crud_local/src/pages/rejection/home_page.dart';
import 'package:crud_local/src/pages/verify_ip.dart';
//import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  await _sharedPreferences.remove('token');

  final themeController = ThemeController(_sharedPreferences);

  Animate.restartOnHotReload = true;
  //await windowManager.ensureInitialized();
  //await WindowManager.instance.maximize();
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
              ('/warning'): (context) => const WarningPage(),
              ('/addErr'): (context) => const AddError(),
              ('/listFilErr'): (context) => const ListFiltErros(),
              ('/editErr'): (context) => EditErr(),
              ('/askPass'): (context) => const AskPassword(),
              ('/askAuthPass'): (context) => const AskAuthPassword(),
              ('/verifyIp'): (context) => const VerifyIp(),
              ('/verifySubToken'): (context) => const VerifySubToken(),
              ('/'): (context) => const HomePage(),
              ('/user'): (context) => const HomeUserPage(),
              ('/getSolution'): (context) => const GetSolution(),
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
          scaffoldBackgroundColor: Color.fromARGB(255, 32, 32, 32),
          textTheme: TextTheme(
            bodyMedium: GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 22,
              fontStyle: FontStyle.italic,
            ),
            bodyLarge: GoogleFonts.ubuntu(
              color: Colors.white.withOpacity(0.5),
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
            titleLarge: GoogleFonts.ubuntu(
                color: Colors.white, fontStyle: FontStyle.italic),
            bodySmall: const TextStyle(
              color: Color.fromARGB(255, 39, 39, 39),
            ),
            headlineMedium: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.5),
            ),
            headlineSmall: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            headlineLarge: const TextStyle(
              fontSize: 14,
              color: Colors.redAccent,
              decoration: TextDecoration.underline,
            ),
            titleSmall: const TextStyle(
              color: Color.fromARGB(255, 73, 73, 73),
            ),
            titleMedium: GoogleFonts.ubuntu(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          colorScheme: const ColorScheme.dark(
              brightness: Brightness.dark,
              primary: Colors.white,
              onPrimary: Colors.blue,
              secondary: Colors.black,
              onSecondary: Colors.blue,
              error: Colors.black,
              onError: Colors.black,
              background: Color.fromARGB(255, 32, 32, 32),
              onBackground: Colors.white,
              surface: Color.fromARGB(255, 41, 41, 41),
              onSurface: Colors.white),
        );
      case "light":
      default:
        return ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 212, 212, 212),
          textTheme: TextTheme(
            bodyMedium: GoogleFonts.ubuntu(
              color: Colors.black,
              fontSize: 22,
              fontStyle: FontStyle.italic,
            ),
            bodyLarge: GoogleFonts.ubuntu(
              color: Colors.black.withOpacity(0.5),
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
            titleLarge: GoogleFonts.ubuntu(
                color: Colors.black, fontStyle: FontStyle.italic),
            bodySmall: const TextStyle(
              color: Colors.white,
            ),
            headlineMedium: TextStyle(
              fontSize: 18,
              color: Colors.black.withOpacity(0.5),
            ),
            headlineSmall: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            headlineLarge: const TextStyle(
              fontSize: 14,
              color: Colors.redAccent,
              decoration: TextDecoration.underline,
            ),
            titleSmall: const TextStyle(
              color: Color.fromARGB(255, 212, 212, 212),
            ),
            titleMedium: GoogleFonts.ubuntu(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          colorScheme: const ColorScheme.light(
              brightness: Brightness.light,
              primary: Colors.black,
              onPrimary: Colors.blue,
              secondary: Colors.white,
              onSecondary: Colors.blue,
              error: Colors.black,
              onError: Colors.black,
              background: Color.fromARGB(255, 212, 212, 212),
              onBackground: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black),
        );
    }
  }
}
