import 'dart:async';
import 'dart:convert';

import 'package:crud_local/src/bloc/user_bloc.dart';
import 'package:crud_local/src/bloc/user_event.dart';
import 'package:crud_local/src/bloc/user_state.dart';
import 'package:crud_local/src/pages/responsive_config.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_indicator/loading_indicator.dart';

class GetSolution extends StatefulWidget {
  const GetSolution({super.key});

  @override
  State<GetSolution> createState() => _GetSolutionState();
}

class _GetSolutionState extends State<GetSolution> {
  final service = ErrorService();
  var viewPass = false;
  final bloc = UserBloc(ErrorService());
  late StreamSubscription sub;

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

  final _CampoPes = TextEditingController();
  late FocusNode myFocusNode;

  _painelPes() {
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
                  width: MediaQuery.of(context).size.width * .7,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: myFocusNode,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Procurar Rejeição',
                      filled: true,
                      fillColor: Theme.of(context).textTheme.titleSmall!.color,
                    ),
                    onEditingComplete: () {
                      sub = bloc.stream.listen((event) {
                        setState(() {});
                      });
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        bloc.add(catchUser(_filtroPes()));
                      });
                      _errors();
                      FocusScope.of(context).unfocus();
                    },
                    controller: _CampoPes,
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  child: IconButton(
                    onPressed: () {
                      sub = bloc.stream.listen((event) {
                        setState(() {});
                      });
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        bloc.add(catchUser(_filtroPes()));
                      });
                      _errors();
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 0.01,
                    child: Checkbox(
                      value: FilCodErr,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          FilCodErr = value!;
                        });
                        myFocusNode.requestFocus();
                      },
                    ),
                  ),
                  const Text(
                    'Código',
                    style: TextStyle(fontSize: 0.01),
                  ),
                ],
              )),
        ],
      )),
    );
  }

  Map<String, dynamic> data = {};
  bool FilCodErr = true;

  _filtroPes() {
    var Filtro;
    if (FilCodErr) {
      Filtro = '/' + _CampoPes.text;
    } else {
      Filtro = '';
    }
    return Filtro;
  }

  _errors() async {
    try {
      Response response;

      response = await service.getSolution(_filtroPes());

      if (response.statusCode == 200) {
        String jsonDataString = response.body;
        if (response.body != 'Nenhum Erro Encontrado') {
          data = jsonDecode(jsonDataString);
        } else {
          dialogs.information(context, 'Aviso',
              'Nenhum Erro encontrado! \n realize outra busca');
        }
      } else {
        data = {};
        dialogs.information(
            context, 'Aviso', 'Nenhum Erro encontrado! \n realize outra busca');
      }
    } catch (e) {
      data = {};
      dialogs.error(context, 'Erro', 'Verifique o IP e tente novamente');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container();
    final state = bloc.state;
    final altura = MediaQuery.of(context).size.height;
    final largura = MediaQuery.of(context).size.width;
    final isMob = isMobile(context);

    if (state is InitialState) {
      body = Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text('Busque por alguma rejeição',
              style: Theme.of(context).textTheme.headlineMedium),
        ),
      );
    }

    if (state is ExceptionState) {
      body = Center(
          child: TextButton(
              onPressed: () {
                bloc.add(catchUser(_filtroPes()));
              },
              child: Text(
                'Erro ao carregar a rejeição',
                style: Theme.of(context).textTheme.headlineMedium,
              )));
    }

    if (state is LoadingState) {
      body = const Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              colors: [Colors.blue],
            ),
          ),
        ),
      );
    }

    if (state is SuccessState) {
      body = Container(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                if (isMob)
                  Container(
                      height: altura * 0.4,
                      width: 700,
                      margin: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Descrição: ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: data['deserr'].toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ]),
                        ),
                        subtitle: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: 'Solução: ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: data['solerr'].toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ])),
                      ))
                else
                  Card(
                      child: ListTile(
                    title: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Descrição: ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: data['deserr'].toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ]),
                    ),
                    subtitle: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'Solução: ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: data['solerr'].toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ])),
                  )),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisar Rejeição'),
      ),
      body: Container(
        height: altura,
        width: largura,
        child: Column(
          children: [_painelPes(), body],
        ),
      ),
    );
  }
}
