// ignore_for_file: avoid_unused_constructor_parameters

// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class DataF<T extends Object> {
  DataF();
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }

  factory DataF.fromMap(
    Map<String, dynamic> map,
  ) {
    throw UnimplementedError();
  }
}
