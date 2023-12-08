import 'dart:convert';

class ErrorModel {
  final int coderr;
  final String? deserr;
  final String? solerr;
  final bool fil;

  ErrorModel(
      {this.coderr = 0, this.deserr = '', this.solerr = '', this.fil = false});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coderr': coderr,
      'deserr': deserr,
      'solerr': solerr,
    };
  }

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(
      coderr: map['coderr'] as int,
      deserr: map['deserr'] as String,
      solerr: map['solerr'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorModel.fromJson(dynamic json) {
    return ErrorModel(
      coderr: json['coderr'],
      deserr: json['deserr'],
      solerr: json['solerr'],
    );
  }
}
