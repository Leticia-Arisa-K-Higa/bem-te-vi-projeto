import 'package:flutter/material.dart';
import 'dart:math';

class Goal {
  final int id;
  final String mainCategory;
  final String secundaryCategory;
  String initialDescription;

  final TextEditingController descriptionController;
  final TextEditingController baselineController;
  final TextEditingController achievedController;
  int importance;
  int difficulty;
  double? baseline;
  double? achieved;

  final TextEditingController levelMinus2Controller;
  final TextEditingController levelMinus1Controller;
  final TextEditingController level0Controller;
  final TextEditingController levelPlus1Controller;
  final TextEditingController levelPlus2Controller;

  Goal({
    required this.id,
    required this.mainCategory,
    required this.secundaryCategory,
    this.initialDescription = '',
    this.importance = 0,
    this.difficulty = 0,
    this.baseline,
    this.achieved,
  }) : descriptionController = TextEditingController(text: initialDescription),
       baselineController = TextEditingController(
         text: baseline?.toString() ?? '',
       ),
       achievedController = TextEditingController(
         text: achieved?.toString() ?? '',
       ),
       levelMinus2Controller = TextEditingController(),
       levelMinus1Controller = TextEditingController(),
       level0Controller = TextEditingController(),
       levelPlus1Controller = TextEditingController(),
       levelPlus2Controller = TextEditingController();

  double get ponderation1 => (importance * difficulty).toDouble();
  double get ponderation2 => pow(ponderation1, 2).toDouble();
  double get ponderation3 => (baseline ?? 0.0) * ponderation1;
  double get ponderation4 => (achieved ?? 0.0) * ponderation1;

  void dispose() {
    descriptionController.dispose();
    baselineController.dispose();
    achievedController.dispose();
    levelMinus2Controller.dispose();
    levelMinus1Controller.dispose();
    level0Controller.dispose();
    levelPlus1Controller.dispose();
    levelPlus2Controller.dispose();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': descriptionController.text,
      'importance': importance,
      'difficulty': difficulty,
      'baseline': baseline,
      'achieved': achieved,
      'level_minus_2': levelMinus2Controller.text,
      'level_minus_1': levelMinus1Controller.text,
      'level_0': level0Controller.text,
      'level_plus_1': levelPlus1Controller.text,
      'level_plus_2': levelPlus2Controller.text,
    };
  }
}
