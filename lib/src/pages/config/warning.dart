import 'package:crud_local/src/pages/responsive_config.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WarningPage extends StatefulWidget {
  const WarningPage({super.key});

  @override
  State<WarningPage> createState() => _WarningPageState();
}

TextEditingController _ipInputController = TextEditingController();
TextEditingController _portInputController = TextEditingController();
final service = ErrorService();
bool loading = false;

class _WarningPageState extends State<WarningPage> {
  @override
  void initState() {
    super.initState();
    service.addListener(() {
      if (service.resultpi == true) {
        dialogs.success(
            context, 'Sucesso', 'Api GetSolution: On \n Api Auth: On');
        setState(() {
          loading = false;
        });
      } else if (service.resultpi == null) {
        dialogs.warning(context, 'Aviso', 'Salve o ip para poder testar');
        loading = false;
      } else {
        dialogs.error(
            context, 'Erro', 'Erro ao conectar-se a API, verifique o ip');
        loading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;
    final isMob = isMobile(context);

    return PopScope(
      canPop: false,
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isMob)
              Container(
                height: altura * 0.6,
                width: 400,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Colors.redAccent,
                      size: 100,
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .scaleXY(
                          begin: 1,
                          end: 1.2,
                          curve: Curves.easeInOut,
                          duration: 1000.ms,
                        )
                        .then()
                        .scaleXY(
                          begin: 1.2,
                          end: 1,
                          curve: Curves.easeInOut,
                          duration: 1000.ms,
                        ),
                    Text(
                      'Não foi possível efetuar a conexão! \n Por favor tente mais tarde.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .popAndPushNamed('/askAuthPass');
                          },
                          child: Text(
                            'CONFIGURAR',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            else
              Container(
                height: altura * 0.6,
                width: largura * 1,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Colors.redAccent,
                      size: 100,
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .scaleXY(
                          begin: 1,
                          end: 1.2,
                          curve: Curves.easeInOut,
                          duration: 1000.ms,
                        )
                        .then()
                        .scaleXY(
                          begin: 1.2,
                          end: 1,
                          curve: Curves.easeInOut,
                          duration: 1000.ms,
                        ),
                    Text(
                      'Não foi possível efetuar a conexão! \n Por favor tente mais tarde.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .popAndPushNamed('/askAuthPass');
                          },
                          child: Text(
                            'CONFIGURAR',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
