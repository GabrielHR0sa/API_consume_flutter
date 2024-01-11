abstract class ErrorState {}

class InitialState extends ErrorState {}

class LoadingState extends ErrorState {}

class ExceptionState extends ErrorState {
  final String message;
  final StackTrace? stackTrace;
  ExceptionState(this.message, this.stackTrace);
}

class SuccessState extends ErrorState {
  final List<dynamic> list;
  SuccessState(this.list);
}
