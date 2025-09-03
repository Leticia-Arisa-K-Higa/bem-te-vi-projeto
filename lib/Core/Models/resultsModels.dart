import 'package:json_annotation/json_annotation.dart';

part 'resultsModels.g.dart';

@JsonSerializable()
class NeurologicalLevels {
  final String sensoryRight;
  final String sensoryLeft;
  final String motorRight;
  final String motorLeft;

  NeurologicalLevels({
    this.sensoryRight = '',
    this.sensoryLeft = '',
    this.motorRight = '',
    this.motorLeft = '',
  });

  factory NeurologicalLevels.fromJson(Map<String, dynamic> json) =>
      _$NeurologicalLevelsFromJson(json);
  Map<String, dynamic> toJson() => _$NeurologicalLevelsToJson(this);
}

@JsonSerializable()
class ZoneOfPartialPreservations {
  final String sensoryRight;
  final String sensoryLeft;
  final String motorRight;
  final String motorLeft;

  ZoneOfPartialPreservations({
    this.sensoryRight = '',
    this.sensoryLeft = '',
    this.motorRight = '',
    this.motorLeft = '',
  });

  factory ZoneOfPartialPreservations.fromJson(Map<String, dynamic> json) =>
      _$ZoneOfPartialPreservationsFromJson(json);
  Map<String, dynamic> toJson() => _$ZoneOfPartialPreservationsToJson(this);
}

@JsonSerializable()
class ClassificationResult {
  final NeurologicalLevels neurologicalLevels;
  final String neurologicalLevelOfInjury;
  final String injuryComplete;
  final String asiaImpairmentScale;
  final ZoneOfPartialPreservations zoneOfPartialPreservations;

  ClassificationResult({
    required this.neurologicalLevels,
    required this.neurologicalLevelOfInjury,
    required this.injuryComplete,
    required this.asiaImpairmentScale,
    required this.zoneOfPartialPreservations,
  });

  factory ClassificationResult.fromJson(Map<String, dynamic> json) =>
      _$ClassificationResultFromJson(json);
  Map<String, dynamic> toJson() => _$ClassificationResultToJson(this);
}

@JsonSerializable()
class TotalsResult {
  final dynamic upperExtremityRight;
  final dynamic upperExtremityLeft;
  final dynamic lowerExtremityRight;
  final dynamic lowerExtremityLeft;
  final dynamic lightTouchRight;
  final dynamic lightTouchLeft;
  final dynamic pinPrickRight;
  final dynamic pinPrickLeft;

  dynamic get upperExtremity => _add(upperExtremityRight, upperExtremityLeft);
  dynamic get lowerExtremity => _add(lowerExtremityRight, lowerExtremityLeft);
  dynamic get rightMotor => _add(upperExtremityRight, lowerExtremityRight);
  dynamic get leftMotor => _add(upperExtremityLeft, lowerExtremityLeft);
  dynamic get lightTouch => _add(lightTouchRight, lightTouchLeft);
  dynamic get pinPrick => _add(pinPrickRight, pinPrickLeft);

  TotalsResult({
    required this.upperExtremityRight,
    required this.upperExtremityLeft,
    required this.lowerExtremityRight,
    required this.lowerExtremityLeft,
    required this.lightTouchRight,
    required this.lightTouchLeft,
    required this.pinPrickRight,
    required this.pinPrickLeft,
  });

  dynamic _add(dynamic a, dynamic b) {
    if (a == 'ND' || b == 'ND') return 'ND';
    if (a is int && b is int) return a + b;
    return 'ND';
  }

  factory TotalsResult.fromJson(Map<String, dynamic> json) =>
      _$TotalsResultFromJson(json);
  Map<String, dynamic> toJson() => _$TotalsResultToJson(this);
}

@JsonSerializable()
class IscnsciResult {
  final ClassificationResult classification;
  final TotalsResult totals;

  IscnsciResult({required this.classification, required this.totals});

  factory IscnsciResult.fromJson(Map<String, dynamic> json) =>
      _$IscnsciResultFromJson(json);
  Map<String, dynamic> toJson() => _$IscnsciResultToJson(this);
}
