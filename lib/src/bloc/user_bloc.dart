import 'dart:convert';

import 'package:crud_local/src/bloc/user_event.dart';
import 'package:crud_local/src/bloc/user_state.dart';
import 'package:crud_local/src/pages/config/config.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ErrorService service;

  UserBloc(this.service) : super(InitialState()) {
    on<catchUser>(_catchUser);
  }
}

Future<void> _catchUser(event, emit) async {
  final model = event.filt;
  emit(LoadingState());
  await Future.delayed(Duration(seconds: 1));

  try {
    Response response;
    response = await service.getSolution(model);
    final toString = response.body.toString();
    final decode = jsonDecode(toString);

    emit(SuccessState(decode));
  } catch (e, s) {
    emit(ExceptionState(e.toString(), s));
  }
}
