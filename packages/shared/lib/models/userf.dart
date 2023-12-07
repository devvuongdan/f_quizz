// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../serializers/date_time_converter.dart';

part 'userf.freezed.dart';
part 'userf.g.dart';

/// {@template user}
/// A class representing a user.
/// {@endtemplate}
@freezed
class UserF with _$UserF {
  /// {@macro user}
  const factory UserF({
    required String id,
    required String username,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
    @DateTimeConverter() required DateTime updatedPwAt,
    @Default('') @JsonKey(includeToJson: false) String password,
  }) = _UserF;

  /// {@macro user}
  /// Create a [User] from a json object.
  factory UserF.fromJson(Map<String, dynamic> json) => _$UserFFromJson(json);
}
