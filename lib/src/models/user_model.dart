// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final int codusu;
  final String nomusu;
  final String logusu;
  final String senusu;

  UserModel({
    this.codusu = 0,
    this.nomusu = '',
    this.logusu = '',
    this.senusu = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codusu': codusu,
      'nomusu': nomusu,
      'logusu': logusu,
      'senusu': senusu,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      codusu: map['codusu'] as int,
      nomusu: map['nomusu'] as String,
      logusu: map['logusu'] as String,
      senusu: map['senusu'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
