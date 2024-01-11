import 'package:crud_local/src/pages/responsive_config.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/widgets/dialogs.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddError extends StatefulWidget {
  const AddError({super.key});

  @override
  State<AddError> createState() => _AddErrorState();
}

class _AddErrorState extends State<AddError> {
  final service = ErrorService();
  bool viewPass = false;

  @override
  void initState() {
    super.initState();
    service.addListener(() {
      setState(() {
        if (service.result == 204) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Rejeição cadastrada com sucesso!',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ));
          Navigator.of(context).popAndPushNamed('/');
          Navigator.of(context).pushNamed('/addErr');
        } else if (service.cod == 0 || service.des == '' || service.sol == '') {
          dialogs.warning(context, 'Aviso', 'Preencha todos os campos');
        } else {
          dialogs.warning(context, 'Aviso', 'Essa rejeição já foi cadastrada');
        }
      });
    });
    viewPass = false;
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;
    final isMob = isMobile(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Adicionar nova rejeição'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isMob)
              Container(
                height: altura * 0.6,
                width: 700,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        onChanged: service.setCodErr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: 'Codigo da rejeição',
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        maxLines: 3,
                        onChanged: service.setDesErr,
                        decoration: const InputDecoration(
                            filled: true, labelText: 'Descrição da rejeição'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        maxLines: 3,
                        onChanged: service.setSolErr,
                        decoration: const InputDecoration(
                            filled: true, labelText: 'Solução da rejeição'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            service.addError();
                          },
                          child: Text(
                            'Salvar',
                            style: GoogleFonts.openSans(
                              fontStyle: FontStyle.italic,
                            ),
                          ))
                    ],
                  ),
                ),
              )
            else
              Container(
                height: altura * 0.6,
                width: largura * 1,
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        onChanged: service.setCodErr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: 'Codigo da rejeição',
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        onChanged: service.setDesErr,
                        decoration: const InputDecoration(
                            filled: true, labelText: 'Descrição da rejeição'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        onChanged: service.setSolErr,
                        decoration: const InputDecoration(
                            filled: true, labelText: 'Solução da rejeição'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            service.addError();
                          },
                          child: Text(
                            'Salvar',
                            style: GoogleFonts.openSans(
                                fontStyle: FontStyle.italic),
                          ))
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
