// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable

import 'package:crud_local/src/models/error_model.dart';
import 'package:crud_local/src/pages/responsive_config.dart';
import 'package:crud_local/src/service/erro_service.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditErr extends StatefulWidget {
  @override
  State<EditErr> createState() => _EditErrState();
}

class _EditErrState extends State<EditErr> {
  final _form = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  void _loadFormData(ErrorModel erro) {
    _formData['coderr'] = '${erro.coderr}';
    _formData['deserr'] = '${erro.deserr}';
    _formData['solerr'] = '${erro.solerr}';
  }

  @override
  Widget build(BuildContext context) {
    final erro = ModalRoute.of(context)!.settings.arguments as ErrorModel;
    final service = ErrorService();
    final isMob = isMobile(context);
    var confirmD = false;
    var confirmS = false;

    _loadFormData(erro);

    if (_formData['deserr'] == 'null') {
      confirmD = true;
    }
    if (_formData['solerr'] == 'null') {
      confirmS = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Dados'),
      ),
      body: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: 30,
                  width: 200,
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Código: ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: _formData['coderr']!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ]))),
            ),
            if (isMob)
              Center(
                child: Container(
                  width: 700,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    initialValue: confirmD ? '' : _formData['deserr'],
                    maxLines: 3,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Descrição',
                    ),
                    validator: (value) {
                      if (value!.length > 200) {
                        return 'Nº de caracteres Máximos permitido é de 200';
                      }
                    },
                    onChanged: service.setDesErr,
                  ),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  initialValue: confirmD ? '' : _formData['deserr'],
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Descrição',
                  ),
                  validator: (value) {
                    if (value!.length > 200) {
                      return 'Nº de caracteres Máximos permitido é de 200';
                    }
                  },
                  onChanged: service.setDesErr,
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            if (isMob)
              Center(
                child: Container(
                  width: 700,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    initialValue: confirmS ? '' : _formData['solerr'],
                    maxLines: 3,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Solução',
                    ),
                    validator: (value) {
                      if (value!.length > 300) {
                        return 'Nº de caracteres Máximos permitido é de 300';
                      }
                    },
                    onChanged: service.setSolErr,
                  ),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  initialValue: confirmS ? '' : _formData['solerr'],
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Solução',
                  ),
                  validator: (value) {
                    if (value!.length > 300) {
                      return 'Nº de caracteres Máximos permitido é de 300';
                    }
                  },
                  onChanged: service.setSolErr,
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences _sharedPreferences =
                      await SharedPreferences.getInstance();
                  var id = _formData['coderr'];
                  await _sharedPreferences.setString('id', id!);

                  service.setCodErr;
                  final isValid = _form.currentState!.validate();

                  if (isValid) {
                    service.updateError();
                    confirmD = false;
                    confirmS = false;
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Rejeição alterada com sucesso',
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Não foi possível alterar a Rejeição',
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                },
                child: Text(
                  'Salvar',
                  style: GoogleFonts.openSans(fontStyle: FontStyle.italic),
                ))
          ],
        ),
      ),
    );
  }
}
