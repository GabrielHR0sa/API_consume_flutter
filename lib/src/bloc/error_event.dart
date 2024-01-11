abstract class ErrorEvent {}

class catchError extends ErrorEvent {
  final dynamic filt;
  catchError(this.filt);
}

class updateError extends ErrorEvent {
  final dynamic filt;
  updateError(this.filt);
}

class deleteError extends ErrorEvent {
  final dynamic filt;
  deleteError(this.filt);
}
