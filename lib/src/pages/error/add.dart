import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/widgets/dialogs.dart';

import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar novo Erro'),
      ),
      body: Center(
        child: Container(
          height: altura * 0.6,
          width: largura * 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                onChanged: service.setCodErr,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Codigo do erro',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                onChanged: service.setDesErr,
                decoration: InputDecoration(labelText: 'Descrição do erro'),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                onChanged: service.setSolErr,
                decoration: InputDecoration(labelText: 'Solução do erro'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    service.addError();
                  },
                  child: const Text(
                    'Salvar',
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
