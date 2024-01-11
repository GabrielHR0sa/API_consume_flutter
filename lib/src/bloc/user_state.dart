abstract class UserState {}

class InitialState extends UserState {}

class LoadingState extends UserState {}

class ExceptionState extends UserState {
  final String message;
  final StackTrace? stackTrace;
  ExceptionState(this.message, this.stackTrace);
}

class SuccessState extends UserState {
  final Map<String, dynamic> map;
  SuccessState(this.map);
}
