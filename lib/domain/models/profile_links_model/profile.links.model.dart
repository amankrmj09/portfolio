import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.links.model.freezed.dart';

part 'profile.links.model.g.dart';

@freezed
abstract class ProfileLinksModel with _$ProfileLinksModel {
  const factory ProfileLinksModel({
    required String name,
    required String icon,
    required String url,
    required String color1,
    required String color2,
  }) = _ProfileLinksModel;

  factory ProfileLinksModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileLinksModelFromJson(json);
}
