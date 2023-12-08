import 'dart:async';
import 'dart:convert';

import 'package:crud_local/src/models/error_model.dart';
import 'package:crud_local/src/pages/error/edit.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListFiltErros extends StatefulWidget {
  const ListFiltErros({super.key});

  @override
  State<ListFiltErros> createState() => _ListFiltErrosState();
}

enum options { FilCod, FilDes, FilSol, FilNul }

class _ListFiltErrosState extends State<ListFiltErros> {
  final service = ErrorService();
  final test = EditErr();
  options? _options = options.FilCod;

  @override
  void initState() {
    myFocusNode = FocusNode();

    super.initState();

    @override
    void dispose() {
      myFocusNode.dispose();
      super.dispose();
    }

    super.initState();
  }

  final _campoPesq = TextEditingController();
  late FocusNode myFocusNode;

  _painelPesq() {
    return Container(
      color: Theme.of(context).textTheme.bodySmall!.color,
      child: Form(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    focusNode: myFocusNode,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                        hintText: 'Procurar Rejeição',
                        filled: true,
                        fillColor: Color.fromARGB(255, 212, 212, 212)),
                    onEditingComplete: () {
                      rejections();
                      Timer(Duration(milliseconds: 20), () {
                        myFocusNode.requestFocus();
                      });

                      FocusScope.of(context).unfocus();
                    },
                    controller: _campoPesq,
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: () {
                      rejections();
                      Timer(Duration(milliseconds: 20), () {
                        myFocusNode.requestFocus();
                      });

                      FocusScope.of(context).unfocus();
                    },
                    icon: const Icon(
                      Icons.refresh,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: const Text(
              'Filtrar por',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Radio<options>(
                    value: options.FilCod,
                    groupValue: _options,
                    onChanged: (options? value) {
                      FocusScope.of(context).unfocus();
                      setState(
                        () {
                          _options = value;
                          FilCod = true;
                          if (FilCod) {
                            FilDes = false;
                            FilSol = false;
                            FilNul = false;
                          }
                        },
                      );
                      myFocusNode.requestFocus();
                    },
                  ),
                ),
                const Text(
                  'Código',
                  style: TextStyle(fontSize: 10),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Radio<options>(
                    value: options.FilDes,
                    groupValue: _options,
                    onChanged: (options? value) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        FilDes = true;
                        if (FilDes) {
                          _options = value;
                          FilCod = false;
                          FilSol = false;
                          FilNul = false;
                        }
                      });
                      myFocusNode.requestFocus();
                    },
                  ),
                ),
                const Text(
                  'Descrição',
                  style: TextStyle(fontSize: 10),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Radio<options>(
                    value: options.FilSol,
                    groupValue: _options,
                    onChanged: (options? value) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        FilSol = true;
                        if (FilSol) {
                          _options = value;
                          FilDes = false;
                          FilCod = false;
                          FilNul = false;
                        }
                      });
                      myFocusNode.requestFocus();
                    },
                  ),
                ),
                const Text(
                  'Solução',
                  style: TextStyle(fontSize: 10),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Radio<options>(
                    value: options.FilNul,
                    groupValue: _options,
                    onChanged: (options? value) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        FilNul = true;
                        if (FilNul) {
                          _options = value;
                          FilDes = false;
                          FilCod = false;
                          FilSol = false;
                        }
                      });
                      myFocusNode.requestFocus();
                    },
                  ),
                ),
                const Text(
                  'Nulos',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  List<dynamic> data = [];
  List<ErrorModel> errors = [];
  bool FilCod = true;
  bool FilDes = false;
  bool FilSol = false;
  bool FilNul = false;

  FiltroPesq() {
    var Filtro;
    if (FilCod) {
      if (_campoPesq.text == '') {
        Filtro = '';
      } else {
        Filtro = '?coderr=' + _campoPesq.text.trim();
      }
    } else if (FilDes) {
      if (_campoPesq.text == '') {
        Filtro = '';
      } else {
        Filtro = '?deserr=' + _campoPesq.text.trim();
      }
    } else if (FilSol) {
      if (_campoPesq.text == '') {
        Filtro = '';
      } else {
        Filtro = '?solerr=' + _campoPesq.text.trim();
      }
    } else if (FilNul) {
      if (_campoPesq.text == '') {
        Filtro = '?deserr=null';
      } else {
        Filtro = '?deserr=null';
      }
    } else {
      Filtro = '';
    }
    return Filtro;
  }

  rejections() async {
    try {
      Response response;
      if (FilCod == false &&
          FilDes == false &&
          FilSol == false &&
          FilNul == false) {
        dialogs.error(context, 'Erro', 'Nenhum Filtro selecionado');
      } else {
        response = await service.catchRejection(FiltroPesq());

        if (response.statusCode == 200) {
          String jsonDataString = response.body.toString();

          if (response.body != 'Nenhuma Rejeição Encontrada') {
            data = jsonDecode(jsonDataString);
            final list = data;
            errors = list.map(ErrorModel.fromJson).toList();
          } else {
            dialogs.warning(context, 'Aviso', 'Nenhuma rejeição encontrada');
          }
        } else {
          data = [];
          dialogs.warning(context, 'Aviso', 'Nenhuma rejeição encontrada');
        }
      }
    } catch (e) {
      data = [];
      dialogs.error(context, 'Erro', 'Verifique o IP e tente novamente');
    }
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisa'),
      ),
      body: Container(
        height: altura,
        width: largura,
        child: Column(
          children: [
            _painelPesq(),
            Container(
              child: Expanded(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final erro = errors[index];
                      return Container(
                          margin: EdgeInsets.all(5),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 16, 62, 100),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: Text(
                                            data[index]['coderr'].toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                        context, '/editErr',
                                                        arguments: erro)
                                                    .then((_) {
                                                  print('teste');
                                                  rejections();
                                                  setState(() {});
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Color.fromARGB(
                                                    255, 88, 132, 168),
                                              )),
                                          IconButton(
                                              onPressed: () async {
                                                SharedPreferences
                                                    _sharedPreferences =
                                                    await SharedPreferences
                                                        .getInstance();
                                                var id = '${erro.coderr}';
                                                await _sharedPreferences
                                                    .setString('id', id);
                                                // ignore: use_build_context_synchronously
                                                showDialog(
                                                  context: context,
                                                  builder: ((context) =>
                                                      AlertDialog(
                                                        title: const Text(
                                                            'Excluir Rejeição'),
                                                        content: const Text(
                                                            'Deseja realmente excluir a Rejeição?'),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false);
                                                            },
                                                            child: const Text(
                                                                'Não'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                            },
                                                            child: const Text(
                                                                'Sim'),
                                                          ),
                                                        ],
                                                      )),
                                                ).then((confirmed) {
                                                  if (confirmed) {
                                                    service.deleteError();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      content: Text(
                                                        'Rejeição deletada com sucesso!',
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                    ));
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Color.fromARGB(
                                                    255, 88, 132, 168),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Descrição: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        TextSpan(
                                          text:
                                              data[index]['deserr'].toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Solução: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        TextSpan(
                                          text:
                                              data[index]['solerr'].toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
