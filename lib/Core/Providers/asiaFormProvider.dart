import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Models/examModels.dart';
import 'package:projeto/Core/Models/neurologyCellData.dart';
import 'package:projeto/Core/Models/resultsModels.dart';

class AsiaFormProvider extends ChangeNotifier {
  List<NeurologyCellData> _cells = [];

  IscnsciResult? _result;
  IscnsciResult? get result => _result;

  String _patientIdentifier = '';

  String? _voluntaryAnalContraction;
  String? _deepAnalPressure;
  String? _rightLowestNonKeyMuscle;
  String? _leftLowestNonKeyMuscle;
  String _comments = '';

  static const List<String> _spinalOrder = [
    'C2',
    'C3',
    'C4',
    'C5',
    'C6',
    'C7',
    'C8',
    'T1',
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'T8',
    'T9',
    'T10',
    'T11',
    'T12',
    'L1',
    'L2',
    'L3',
    'L4',
    'L5',
    'S1',
    'S2',
    'S3',
    'S4-5',
  ];

  AsiaFormProvider() {
    _initializeCells();
  }

  List<NeurologyCellData> get cells => _cells;
  String get patientIdentifier => _patientIdentifier;
  String? get voluntaryAnalContraction => _voluntaryAnalContraction;
  String? get deepAnalPressure => _deepAnalPressure;
  String? get rightLowestNonKeyMuscle => _rightLowestNonKeyMuscle;
  String? get leftLowestNonKeyMuscle => _leftLowestNonKeyMuscle;
  String get comments => _comments;

  void setPatientIdentifier(String value) {
    _patientIdentifier = value;
    notifyListeners();
  }

  void setFinalResult(IscnsciResult newResult) {
    _result = newResult;
    notifyListeners();
  }

  void _initializeCells() {
    final List<NeurologyCellData> initialCells = [];
    for (String level in AppStrings.sensoryLevels) {
      initialCells.addAll([
        NeurologyCellData(
          id: '${level}RightLT',
          type: CellType.sensoryLightTouch,
          side: Side.right,
          level: level,
          title: '$level Light Touch Right',
          value: '',
        ),
        NeurologyCellData(
          id: '${level}RightEA',
          type: CellType.sensoryPinPrick,
          side: Side.right,
          level: level,
          title: '$level Pin Prick Right',
          value: '',
        ),
        NeurologyCellData(
          id: '${level}LeftLT',
          type: CellType.sensoryLightTouch,
          side: Side.left,
          level: level,
          title: '$level Light Touch Left',
          value: '',
        ),
        NeurologyCellData(
          id: '${level}LeftEA',
          type: CellType.sensoryPinPrick,
          side: Side.left,
          level: level,
          title: '$level Pin Prick Left',
          value: '',
        ),
      ]);
    }
    for (String level in AppStrings.motorLevels) {
      initialCells.addAll([
        NeurologyCellData(
          id: '${level}RightMotor',
          type: CellType.motor,
          side: Side.right,
          level: level,
          title: '$level Motor Right',
          helperText: AppStrings.motorHelpers[level],
          value: '',
        ),
        NeurologyCellData(
          id: '${level}LeftMotor',
          type: CellType.motor,
          side: Side.left,
          level: level,
          title: '$level Motor Left',
          helperText: AppStrings.motorHelpers[level],
          value: '',
        ),
      ]);
    }
    _cells = initialCells;
  }

  void updateCellValue(String cellId, String? newValue) {
    if (newValue == null) return;
    final originalCellIndex = _cells.indexWhere((cell) => cell.id == cellId);
    if (originalCellIndex == -1) return;
    final originalCell = _cells[originalCellIndex];
    _cells[originalCellIndex] = originalCell.copyWith(value: newValue);
    if (newValue.isEmpty) {
      notifyListeners();
      return;
    }
    final originalLevelIndex = _spinalOrder.indexOf(originalCell.level);
    if (originalLevelIndex == -1) {
      notifyListeners();
      return;
    }
    for (int i = originalLevelIndex + 1; i < _spinalOrder.length; i++) {
      final lowerLevel = _spinalOrder[i];
      final lowerCellIndex = _cells.indexWhere(
        (cell) =>
            cell.level == lowerLevel &&
            cell.side == originalCell.side &&
            cell.type == originalCell.type,
      );
      if (lowerCellIndex != -1) {
        _cells[lowerCellIndex] = _cells[lowerCellIndex].copyWith(
          value: newValue,
        );
      }
    }
    notifyListeners();
  }

  Exam createExamFromCells() {
    MotorValues rightMotor = {};
    SensoryValues rightLt = {};
    SensoryValues rightPp = {};
    MotorValues leftMotor = {};
    SensoryValues leftLt = {};
    SensoryValues leftPp = {};

    for (final cell in _cells) {
      final levelKey = cell.level.replaceAll('-', '_');
      final value = cell.value ?? '';

      if (cell.side == Side.right) {
        if (cell.type == CellType.motor) rightMotor[levelKey] = value;
        if (cell.type == CellType.sensoryLightTouch) rightLt[levelKey] = value;
        if (cell.type == CellType.sensoryPinPrick) rightPp[levelKey] = value;
      } else {
        if (cell.type == CellType.motor) leftMotor[levelKey] = value;
        if (cell.type == CellType.sensoryLightTouch) leftLt[levelKey] = value;
        if (cell.type == CellType.sensoryPinPrick) leftPp[levelKey] = value;
      }
    }

    return Exam(
      patientIdentifier: _patientIdentifier,

      right: ExamSide(
        motor: rightMotor,
        lightTouch: rightLt,
        pinPrick: rightPp,
        lowestNonKeyMuscleWithMotorFunction: _rightLowestNonKeyMuscle,
      ),
      left: ExamSide(
        motor: leftMotor,
        lightTouch: leftLt,
        pinPrick: leftPp,
        lowestNonKeyMuscleWithMotorFunction: _leftLowestNonKeyMuscle,
      ),
      voluntaryAnalContraction: _voluntaryAnalContraction ?? 'No',
      deepAnalPressure: _deepAnalPressure ?? 'No',
    );
  }

  void setVoluntaryAnalContraction(String? value) {
    _voluntaryAnalContraction = value;
    notifyListeners();
  }

  void setDeepAnalPressure(String? value) {
    _deepAnalPressure = value;
    notifyListeners();
  }

  void setRightLowestNonKeyMuscle(String? value) {
    _rightLowestNonKeyMuscle = value;
    notifyListeners();
  }

  void setLeftLowestNonKeyMuscle(String? value) {
    _leftLowestNonKeyMuscle = value;
    notifyListeners();
  }

  void setComments(String value) {
    _comments = value;
    notifyListeners();
  }

  void clearForm() {
    _initializeCells();
    _voluntaryAnalContraction = null;
    _deepAnalPressure = null;
    _rightLowestNonKeyMuscle = null;
    _leftLowestNonKeyMuscle = null;
    _comments = '';
    notifyListeners();
  }
}
