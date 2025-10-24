import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

@freezed
abstract class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    required String name,
    required List<String> techStack,
    required String duration,
    required String description,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
}
