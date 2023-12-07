import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ResultF {
  final String message;
  final bool ok;
  const ResultF({
    required this.message,
    required this.ok,
  });

  @override
  String toString() => 'ResultF(message: $message, ok: $ok)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'ok': ok,
    };
  }

  factory ResultF.fromMap(Map<String, dynamic> map) {
    return ResultF(
      message: map['message'] as String,
      ok: map['ok'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultF.fromJson(String source) =>
      ResultF.fromMap(json.decode(source) as Map<String, dynamic>);
}
