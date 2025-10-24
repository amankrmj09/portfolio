// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resume_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResumeModel {

 List<EducationModel> get education; List<WorkExperienceModel> get workExperience; List<ProjectModel> get projects; List<CertificateModel> get certificates; List<AchievementModel> get achievements;
/// Create a copy of ResumeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeModelCopyWith<ResumeModel> get copyWith => _$ResumeModelCopyWithImpl<ResumeModel>(this as ResumeModel, _$identity);

  /// Serializes this ResumeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeModel&&const DeepCollectionEquality().equals(other.education, education)&&const DeepCollectionEquality().equals(other.workExperience, workExperience)&&const DeepCollectionEquality().equals(other.projects, projects)&&const DeepCollectionEquality().equals(other.certificates, certificates)&&const DeepCollectionEquality().equals(other.achievements, achievements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(education),const DeepCollectionEquality().hash(workExperience),const DeepCollectionEquality().hash(projects),const DeepCollectionEquality().hash(certificates),const DeepCollectionEquality().hash(achievements));

@override
String toString() {
  return 'ResumeModel(education: $education, workExperience: $workExperience, projects: $projects, certificates: $certificates, achievements: $achievements)';
}


}

/// @nodoc
abstract mixin class $ResumeModelCopyWith<$Res>  {
  factory $ResumeModelCopyWith(ResumeModel value, $Res Function(ResumeModel) _then) = _$ResumeModelCopyWithImpl;
@useResult
$Res call({
 List<EducationModel> education, List<WorkExperienceModel> workExperience, List<ProjectModel> projects, List<CertificateModel> certificates, List<AchievementModel> achievements
});




}
/// @nodoc
class _$ResumeModelCopyWithImpl<$Res>
    implements $ResumeModelCopyWith<$Res> {
  _$ResumeModelCopyWithImpl(this._self, this._then);

  final ResumeModel _self;
  final $Res Function(ResumeModel) _then;

/// Create a copy of ResumeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? education = null,Object? workExperience = null,Object? projects = null,Object? certificates = null,Object? achievements = null,}) {
  return _then(_self.copyWith(
education: null == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as List<EducationModel>,workExperience: null == workExperience ? _self.workExperience : workExperience // ignore: cast_nullable_to_non_nullable
as List<WorkExperienceModel>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectModel>,certificates: null == certificates ? _self.certificates : certificates // ignore: cast_nullable_to_non_nullable
as List<CertificateModel>,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<AchievementModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ResumeModel].
extension ResumeModelPatterns on ResumeModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResumeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResumeModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResumeModel value)  $default,){
final _that = this;
switch (_that) {
case _ResumeModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResumeModel value)?  $default,){
final _that = this;
switch (_that) {
case _ResumeModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<EducationModel> education,  List<WorkExperienceModel> workExperience,  List<ProjectModel> projects,  List<CertificateModel> certificates,  List<AchievementModel> achievements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResumeModel() when $default != null:
return $default(_that.education,_that.workExperience,_that.projects,_that.certificates,_that.achievements);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<EducationModel> education,  List<WorkExperienceModel> workExperience,  List<ProjectModel> projects,  List<CertificateModel> certificates,  List<AchievementModel> achievements)  $default,) {final _that = this;
switch (_that) {
case _ResumeModel():
return $default(_that.education,_that.workExperience,_that.projects,_that.certificates,_that.achievements);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<EducationModel> education,  List<WorkExperienceModel> workExperience,  List<ProjectModel> projects,  List<CertificateModel> certificates,  List<AchievementModel> achievements)?  $default,) {final _that = this;
switch (_that) {
case _ResumeModel() when $default != null:
return $default(_that.education,_that.workExperience,_that.projects,_that.certificates,_that.achievements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResumeModel implements ResumeModel {
  const _ResumeModel({required final  List<EducationModel> education, required final  List<WorkExperienceModel> workExperience, required final  List<ProjectModel> projects, required final  List<CertificateModel> certificates, required final  List<AchievementModel> achievements}): _education = education,_workExperience = workExperience,_projects = projects,_certificates = certificates,_achievements = achievements;
  factory _ResumeModel.fromJson(Map<String, dynamic> json) => _$ResumeModelFromJson(json);

 final  List<EducationModel> _education;
@override List<EducationModel> get education {
  if (_education is EqualUnmodifiableListView) return _education;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_education);
}

 final  List<WorkExperienceModel> _workExperience;
@override List<WorkExperienceModel> get workExperience {
  if (_workExperience is EqualUnmodifiableListView) return _workExperience;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workExperience);
}

 final  List<ProjectModel> _projects;
@override List<ProjectModel> get projects {
  if (_projects is EqualUnmodifiableListView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projects);
}

 final  List<CertificateModel> _certificates;
@override List<CertificateModel> get certificates {
  if (_certificates is EqualUnmodifiableListView) return _certificates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_certificates);
}

 final  List<AchievementModel> _achievements;
@override List<AchievementModel> get achievements {
  if (_achievements is EqualUnmodifiableListView) return _achievements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_achievements);
}


/// Create a copy of ResumeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResumeModelCopyWith<_ResumeModel> get copyWith => __$ResumeModelCopyWithImpl<_ResumeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResumeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResumeModel&&const DeepCollectionEquality().equals(other._education, _education)&&const DeepCollectionEquality().equals(other._workExperience, _workExperience)&&const DeepCollectionEquality().equals(other._projects, _projects)&&const DeepCollectionEquality().equals(other._certificates, _certificates)&&const DeepCollectionEquality().equals(other._achievements, _achievements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_education),const DeepCollectionEquality().hash(_workExperience),const DeepCollectionEquality().hash(_projects),const DeepCollectionEquality().hash(_certificates),const DeepCollectionEquality().hash(_achievements));

@override
String toString() {
  return 'ResumeModel(education: $education, workExperience: $workExperience, projects: $projects, certificates: $certificates, achievements: $achievements)';
}


}

/// @nodoc
abstract mixin class _$ResumeModelCopyWith<$Res> implements $ResumeModelCopyWith<$Res> {
  factory _$ResumeModelCopyWith(_ResumeModel value, $Res Function(_ResumeModel) _then) = __$ResumeModelCopyWithImpl;
@override @useResult
$Res call({
 List<EducationModel> education, List<WorkExperienceModel> workExperience, List<ProjectModel> projects, List<CertificateModel> certificates, List<AchievementModel> achievements
});




}
/// @nodoc
class __$ResumeModelCopyWithImpl<$Res>
    implements _$ResumeModelCopyWith<$Res> {
  __$ResumeModelCopyWithImpl(this._self, this._then);

  final _ResumeModel _self;
  final $Res Function(_ResumeModel) _then;

/// Create a copy of ResumeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? education = null,Object? workExperience = null,Object? projects = null,Object? certificates = null,Object? achievements = null,}) {
  return _then(_ResumeModel(
education: null == education ? _self._education : education // ignore: cast_nullable_to_non_nullable
as List<EducationModel>,workExperience: null == workExperience ? _self._workExperience : workExperience // ignore: cast_nullable_to_non_nullable
as List<WorkExperienceModel>,projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectModel>,certificates: null == certificates ? _self._certificates : certificates // ignore: cast_nullable_to_non_nullable
as List<CertificateModel>,achievements: null == achievements ? _self._achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<AchievementModel>,
  ));
}


}

// dart format on
