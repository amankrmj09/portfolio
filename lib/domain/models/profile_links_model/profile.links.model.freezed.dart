// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.links.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileLinksModel {

 String get name; String get icon; String get url; String get color1; String get color2;
/// Create a copy of ProfileLinksModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileLinksModelCopyWith<ProfileLinksModel> get copyWith => _$ProfileLinksModelCopyWithImpl<ProfileLinksModel>(this as ProfileLinksModel, _$identity);

  /// Serializes this ProfileLinksModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileLinksModel&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.url, url) || other.url == url)&&(identical(other.color1, color1) || other.color1 == color1)&&(identical(other.color2, color2) || other.color2 == color2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,icon,url,color1,color2);

@override
String toString() {
  return 'ProfileLinksModel(name: $name, icon: $icon, url: $url, color1: $color1, color2: $color2)';
}


}

/// @nodoc
abstract mixin class $ProfileLinksModelCopyWith<$Res>  {
  factory $ProfileLinksModelCopyWith(ProfileLinksModel value, $Res Function(ProfileLinksModel) _then) = _$ProfileLinksModelCopyWithImpl;
@useResult
$Res call({
 String name, String icon, String url, String color1, String color2
});




}
/// @nodoc
class _$ProfileLinksModelCopyWithImpl<$Res>
    implements $ProfileLinksModelCopyWith<$Res> {
  _$ProfileLinksModelCopyWithImpl(this._self, this._then);

  final ProfileLinksModel _self;
  final $Res Function(ProfileLinksModel) _then;

/// Create a copy of ProfileLinksModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? icon = null,Object? url = null,Object? color1 = null,Object? color2 = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,color1: null == color1 ? _self.color1 : color1 // ignore: cast_nullable_to_non_nullable
as String,color2: null == color2 ? _self.color2 : color2 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileLinksModel].
extension ProfileLinksModelPatterns on ProfileLinksModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileLinksModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileLinksModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileLinksModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileLinksModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileLinksModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileLinksModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String icon,  String url,  String color1,  String color2)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileLinksModel() when $default != null:
return $default(_that.name,_that.icon,_that.url,_that.color1,_that.color2);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String icon,  String url,  String color1,  String color2)  $default,) {final _that = this;
switch (_that) {
case _ProfileLinksModel():
return $default(_that.name,_that.icon,_that.url,_that.color1,_that.color2);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String icon,  String url,  String color1,  String color2)?  $default,) {final _that = this;
switch (_that) {
case _ProfileLinksModel() when $default != null:
return $default(_that.name,_that.icon,_that.url,_that.color1,_that.color2);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileLinksModel implements ProfileLinksModel {
  const _ProfileLinksModel({required this.name, required this.icon, required this.url, required this.color1, required this.color2});
  factory _ProfileLinksModel.fromJson(Map<String, dynamic> json) => _$ProfileLinksModelFromJson(json);

@override final  String name;
@override final  String icon;
@override final  String url;
@override final  String color1;
@override final  String color2;

/// Create a copy of ProfileLinksModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileLinksModelCopyWith<_ProfileLinksModel> get copyWith => __$ProfileLinksModelCopyWithImpl<_ProfileLinksModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileLinksModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileLinksModel&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.url, url) || other.url == url)&&(identical(other.color1, color1) || other.color1 == color1)&&(identical(other.color2, color2) || other.color2 == color2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,icon,url,color1,color2);

@override
String toString() {
  return 'ProfileLinksModel(name: $name, icon: $icon, url: $url, color1: $color1, color2: $color2)';
}


}

/// @nodoc
abstract mixin class _$ProfileLinksModelCopyWith<$Res> implements $ProfileLinksModelCopyWith<$Res> {
  factory _$ProfileLinksModelCopyWith(_ProfileLinksModel value, $Res Function(_ProfileLinksModel) _then) = __$ProfileLinksModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String icon, String url, String color1, String color2
});




}
/// @nodoc
class __$ProfileLinksModelCopyWithImpl<$Res>
    implements _$ProfileLinksModelCopyWith<$Res> {
  __$ProfileLinksModelCopyWithImpl(this._self, this._then);

  final _ProfileLinksModel _self;
  final $Res Function(_ProfileLinksModel) _then;

/// Create a copy of ProfileLinksModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? icon = null,Object? url = null,Object? color1 = null,Object? color2 = null,}) {
  return _then(_ProfileLinksModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,color1: null == color1 ? _self.color1 : color1 // ignore: cast_nullable_to_non_nullable
as String,color2: null == color2 ? _self.color2 : color2 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
