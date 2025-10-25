import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.model.freezed.dart';

part 'project.model.g.dart';

@freezed
abstract class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    required String name,
    required String description,
    required String url,
    required List<String> images,
    required String largeDescription,
    required List<String> techStack,
    required String type,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
}
