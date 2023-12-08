// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final int codusu;
  final String nomusu;
  final String logusu;
  final String senusu;
  final String datcad;
  final bool usuati;

  UserModel({
    this.codusu = 0,
    this.nomusu = '',
    this.logusu = '',
    this.senusu = '',
    this.datcad = '',
    this.usuati = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codusu': codusu,
      'nomusu': nomusu,
      'logusu': logusu,
      'senusu': senusu,
      'datcad': datcad,
      'usuati': usuati,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      codusu: map['codusu'] as int,
      nomusu: map['nomusu'] as String,
      logusu: map['logusu'] as String,
      senusu: map['senusu'] as String,
      datcad: map['datcad'] as String,
      usuati: map['usuati'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      codusu: json['codusu'],
      nomusu: json['nomusu'],
      logusu: json['logusu'],
      datcad: json['datcad'],
      usuati: json['usuati'],
    );
  }
}
