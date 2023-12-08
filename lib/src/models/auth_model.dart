class AuthModel {
  final String user;
  final String pass;

  AuthModel({
    this.user = '',
    this.pass = '',
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      AuthModel(user: json['user'], pass: json['pass']);

  Map<String, dynamic> toJson() => {"user": "user", "pass": "pass"};
}
