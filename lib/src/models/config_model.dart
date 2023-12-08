// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Config {
  final String ip;

  Config({this.ip = ''});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ip': ip,
    };
  }

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      ip: map['ip'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Config.fromJson(String source) =>
      Config.fromMap(json.decode(source) as Map<String, dynamic>);
}
