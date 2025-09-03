// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resultsModels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NeurologicalLevels _$NeurologicalLevelsFromJson(Map<String, dynamic> json) =>
    NeurologicalLevels(
      sensoryRight: json['sensoryRight'] as String? ?? '',
      sensoryLeft: json['sensoryLeft'] as String? ?? '',
      motorRight: json['motorRight'] as String? ?? '',
      motorLeft: json['motorLeft'] as String? ?? '',
    );

Map<String, dynamic> _$NeurologicalLevelsToJson(NeurologicalLevels instance) =>
    <String, dynamic>{
      'sensoryRight': instance.sensoryRight,
      'sensoryLeft': instance.sensoryLeft,
      'motorRight': instance.motorRight,
      'motorLeft': instance.motorLeft,
    };

ZoneOfPartialPreservations _$ZoneOfPartialPreservationsFromJson(
  Map<String, dynamic> json,
) => ZoneOfPartialPreservations(
  sensoryRight: json['sensoryRight'] as String? ?? '',
  sensoryLeft: json['sensoryLeft'] as String? ?? '',
  motorRight: json['motorRight'] as String? ?? '',
  motorLeft: json['motorLeft'] as String? ?? '',
);

Map<String, dynamic> _$ZoneOfPartialPreservationsToJson(
  ZoneOfPartialPreservations instance,
) => <String, dynamic>{
  'sensoryRight': instance.sensoryRight,
  'sensoryLeft': instance.sensoryLeft,
  'motorRight': instance.motorRight,
  'motorLeft': instance.motorLeft,
};

ClassificationResult _$ClassificationResultFromJson(
  Map<String, dynamic> json,
) => ClassificationResult(
  neurologicalLevels: NeurologicalLevels.fromJson(
    json['neurologicalLevels'] as Map<String, dynamic>,
  ),
  neurologicalLevelOfInjury: json['neurologicalLevelOfInjury'] as String,
  injuryComplete: json['injuryComplete'] as String,
  asiaImpairmentScale: json['asiaImpairmentScale'] as String,
  zoneOfPartialPreservations: ZoneOfPartialPreservations.fromJson(
    json['zoneOfPartialPreservations'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ClassificationResultToJson(
  ClassificationResult instance,
) => <String, dynamic>{
  'neurologicalLevels': instance.neurologicalLevels,
  'neurologicalLevelOfInjury': instance.neurologicalLevelOfInjury,
  'injuryComplete': instance.injuryComplete,
  'asiaImpairmentScale': instance.asiaImpairmentScale,
  'zoneOfPartialPreservations': instance.zoneOfPartialPreservations,
};

TotalsResult _$TotalsResultFromJson(Map<String, dynamic> json) => TotalsResult(
  upperExtremityRight: json['upperExtremityRight'],
  upperExtremityLeft: json['upperExtremityLeft'],
  lowerExtremityRight: json['lowerExtremityRight'],
  lowerExtremityLeft: json['lowerExtremityLeft'],
  lightTouchRight: json['lightTouchRight'],
  lightTouchLeft: json['lightTouchLeft'],
  pinPrickRight: json['pinPrickRight'],
  pinPrickLeft: json['pinPrickLeft'],
);

Map<String, dynamic> _$TotalsResultToJson(TotalsResult instance) =>
    <String, dynamic>{
      'upperExtremityRight': instance.upperExtremityRight,
      'upperExtremityLeft': instance.upperExtremityLeft,
      'lowerExtremityRight': instance.lowerExtremityRight,
      'lowerExtremityLeft': instance.lowerExtremityLeft,
      'lightTouchRight': instance.lightTouchRight,
      'lightTouchLeft': instance.lightTouchLeft,
      'pinPrickRight': instance.pinPrickRight,
      'pinPrickLeft': instance.pinPrickLeft,
    };

IscnsciResult _$IscnsciResultFromJson(Map<String, dynamic> json) =>
    IscnsciResult(
      classification: ClassificationResult.fromJson(
        json['classification'] as Map<String, dynamic>,
      ),
      totals: TotalsResult.fromJson(json['totals'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IscnsciResultToJson(IscnsciResult instance) =>
    <String, dynamic>{
      'classification': instance.classification,
      'totals': instance.totals,
    };
