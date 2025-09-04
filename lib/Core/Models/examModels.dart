import 'package:json_annotation/json_annotation.dart';

part 'examModels.g.dart';

// Estrutura para os valores de Músculos-chave. Ex: { 'C5': '5', 'C6': '4*' }
typedef MotorValues = Map<String, String>;

// Estrutura para os valores de Pontos Sensoriais. Ex: { 'C2': '2', 'C3': '1' }
typedef SensoryValues = Map<String, String>;

@JsonSerializable()
class ExamSide {
  final MotorValues motor;
  final SensoryValues lightTouch;
  final SensoryValues pinPrick;
  final String? lowestNonKeyMuscleWithMotorFunction;

  ExamSide({
    required this.motor,
    required this.lightTouch,
    required this.pinPrick,
    this.lowestNonKeyMuscleWithMotorFunction,
  });

  factory ExamSide.fromJson(Map<String, dynamic> json) =>
      _$ExamSideFromJson(json);
  Map<String, dynamic> toJson() => _$ExamSideToJson(this);
}

@JsonSerializable()
class Exam {
  final String patientName;
  final String examDate;
  final String examinerName;

  final ExamSide right;
  final ExamSide left;
  final String voluntaryAnalContraction;
  final String deepAnalPressure;

  Exam({
    required this.patientName,
    required this.examDate,
    required this.examinerName,
    required this.right,
    required this.left,
    required this.voluntaryAnalContraction,
    required this.deepAnalPressure,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);
  Map<String, dynamic> toJson() => _$ExamToJson(this);
}
