// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examModels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamSide _$ExamSideFromJson(Map<String, dynamic> json) => ExamSide(
  motor: Map<String, String>.from(json['motor'] as Map),
  lightTouch: Map<String, String>.from(json['lightTouch'] as Map),
  pinPrick: Map<String, String>.from(json['pinPrick'] as Map),
  lowestNonKeyMuscleWithMotorFunction:
      json['lowestNonKeyMuscleWithMotorFunction'] as String?,
);

Map<String, dynamic> _$ExamSideToJson(ExamSide instance) => <String, dynamic>{
  'motor': instance.motor,
  'lightTouch': instance.lightTouch,
  'pinPrick': instance.pinPrick,
  'lowestNonKeyMuscleWithMotorFunction':
      instance.lowestNonKeyMuscleWithMotorFunction,
};

Exam _$ExamFromJson(Map<String, dynamic> json) => Exam(
  patientName: json['patientName'] as String,
  examDate: json['examDate'] as String,
  examinerName: json['examinerName'] as String,
  right: ExamSide.fromJson(json['right'] as Map<String, dynamic>),
  left: ExamSide.fromJson(json['left'] as Map<String, dynamic>),
  voluntaryAnalContraction: json['voluntaryAnalContraction'] as String,
  deepAnalPressure: json['deepAnalPressure'] as String,
);

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
  'patientName': instance.patientName,
  'examDate': instance.examDate,
  'examinerName': instance.examinerName,
  'right': instance.right,
  'left': instance.left,
  'voluntaryAnalContraction': instance.voluntaryAnalContraction,
  'deepAnalPressure': instance.deepAnalPressure,
};
