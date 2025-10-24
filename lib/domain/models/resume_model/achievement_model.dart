import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_model.freezed.dart';
part 'achievement_model.g.dart';

@freezed
abstract class AchievementModel with _$AchievementModel {
  const factory AchievementModel({
    required String title,
    required String event,
    required String description,
  }) = _AchievementModel;

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);
}
