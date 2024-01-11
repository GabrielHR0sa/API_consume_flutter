import 'dart:convert';

import 'package:crud_local/src/bloc/error_event.dart';
import 'package:crud_local/src/pages/config/config.dart';
import 'package:crud_local/src/service/erro_service.dart';
import 'package:crud_local/src/bloc/error_state.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  final ErrorService service;

  ErrorBloc(this.service) : super(InitialState()) {
    on<catchError>(_catchError);
    on<deleteError>(_deleteError);
    on<updateError>(_updateError);
  }
}

Future<void> _catchError(event, emit) async {
  final model = event.filt;
  emit(LoadingState());
  await Future.delayed(Duration(seconds: 1));

  try {
    Response response;
    response = await service.catchRejection(model);
    final toString = response.body.toString();
    final decode = jsonDecode(toString);

    emit(SuccessState(decode));
  } catch (e, s) {
    emit(ExceptionState(e.toString(), s));
  }
}

Future<void> _deleteError(event, emit) async {
  final model = event.filt;
  emit(LoadingState());
  await Future.delayed(Duration(seconds: 1));

  try {
    await service.deleteError();
    Response response;
    response = await service.catchRejection(model);
    final toString = response.body.toString();
    final decode = jsonDecode(toString);

    emit(SuccessState(decode));
  } catch (e, s) {
    emit(ExceptionState(e.toString(), s));
  }
}

Future<void> _updateError(event, emit) async {
  final model = event.filt;
  emit(LoadingState());
  await Future.delayed(Duration(seconds: 1));

  try {
    await service.updateError();
    Response response;
    response = await service.catchRejection(model);
    final toString = response.body.toString();
    final decode = jsonDecode(toString);

    emit(SuccessState(decode));
  } catch (e, s) {
    emit(ExceptionState(e.toString(), s));
  }
}
