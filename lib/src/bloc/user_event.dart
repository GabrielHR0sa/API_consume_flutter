abstract class UserEvent {}

class catchUser extends UserEvent {
  final dynamic filt;
  catchUser(this.filt);
}
