import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_experience_model.freezed.dart';
part 'work_experience_model.g.dart';

@freezed
abstract class WorkExperienceModel with _$WorkExperienceModel {
  const factory WorkExperienceModel({
    required String company,
    required String role,
    required String duration,
    required String location,
    required String description,
  }) = _WorkExperienceModel;

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceModelFromJson(json);
}
