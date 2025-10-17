import 'dart:convert';

import 'package:flutter/material.dart';

class MuscleData {
  final TextEditingController reobaseDireito = TextEditingController();
  final TextEditingController acomodacaoDireito = TextEditingController();
  final TextEditingController cronaxiaDireito = TextEditingController();

  final TextEditingController reobaseEsquerdo = TextEditingController();
  final TextEditingController acomodacaoEsquerdo = TextEditingController();
  final TextEditingController cronaxiaEsquerdo = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  final VoidCallback onChange;
  MuscleData({required this.onChange}) {
    reobaseDireito.addListener(onChange);
    acomodacaoDireito.addListener(onChange);
    reobaseEsquerdo.addListener(onChange);
    acomodacaoEsquerdo.addListener(onChange);
  }

  String get indiceAcomodacaoDireito {
    final reobase = double.tryParse(reobaseDireito.text);
    final acomodacao = double.tryParse(acomodacaoDireito.text);
    if (reobase != null && acomodacao != null && reobase > 0) {
      return (acomodacao / reobase).toStringAsFixed(1);
    }
    return 'N/A';
  }

  String get indiceAcomodacaoEsquerdo {
    final reobase = double.tryParse(reobaseEsquerdo.text);
    final acomodacao = double.tryParse(acomodacaoEsquerdo.text);
    if (reobase != null && acomodacao != null && reobase > 0) {
      return (acomodacao / reobase).toStringAsFixed(1);
    }
    return 'N/A';
  }

  void dispose() {
    reobaseDireito.dispose();
    acomodacaoDireito.dispose();
    cronaxiaDireito.dispose();
    reobaseEsquerdo.dispose();
    acomodacaoEsquerdo.dispose();
    cronaxiaEsquerdo.dispose();
  }
}

class EletrodiagnosticoProvider with ChangeNotifier {
  final TextEditingController pacienteController = TextEditingController();
  final TextEditingController avaliadorController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController equipamentoController = TextEditingController();

  late final Map<String, MuscleData> muscleDataMap;

  EletrodiagnosticoProvider() {
    muscleDataMap = {
      'Bíceps Braquial': MuscleData(onChange: update),
      'Extensores de Punho': MuscleData(onChange: update),
      'Tríceps Braquial': MuscleData(onChange: update),
      'Grande Dorsal': MuscleData(onChange: update),
      'Deltóide': MuscleData(onChange: update),
      'Reto Abdominal': MuscleData(onChange: update),
      'Vasto Medial': MuscleData(onChange: update),
      'Vasto Lateral': MuscleData(onChange: update),
      'Tibial Anterior': MuscleData(onChange: update),
      'Tríceps Sural': MuscleData(onChange: update),
      'Glúteos': MuscleData(onChange: update),
      'Isquiotibiais': MuscleData(onChange: update),
    };
  }

  void update() {
    notifyListeners();
  }

  @override
  void dispose() {
    pacienteController.dispose();
    avaliadorController.dispose();
    dataController.dispose();
    equipamentoController.dispose();
    for (var data in muscleDataMap.values) {
      data.dispose();
    }
    super.dispose();
  }

  String formatForApi() {
    Map<String, dynamic> header = {
      'patientName': pacienteController.text,
      'examinerName': avaliadorController.text,
      'examDate': dataController.text,
      'equipmentName': equipamentoController.text,
    };

    double? tryParse(String text) {
      if (text.isEmpty) return null;
      return double.tryParse(text.replaceAll(',', '.'));
    }

    List<Map<String, dynamic>> muscleList = [];
    muscleDataMap.forEach((muscleName, data) {
      muscleList.add({
        'muscleName': muscleName,
        'right': {
          'reobase': tryParse(data.reobaseDireito.text),
          'accommodation': tryParse(data.acomodacaoDireito.text),
          'chronaxy': tryParse(data.cronaxiaDireito.text),
          'accommodationIndex': data.indiceAcomodacaoDireito,
        },
        'left': {
          'reobase': tryParse(data.reobaseEsquerdo.text),
          'accommodation': tryParse(data.acomodacaoEsquerdo.text),
          'chronaxy': tryParse(data.cronaxiaEsquerdo.text),
          'accommodationIndex': data.indiceAcomodacaoEsquerdo,
        },
        'comments': data.observacoesController.text.isEmpty
            ? null
            : data.observacoesController.text,
      });
    });

    Map<String, dynamic> payload = {...header, 'muscles': muscleList};

    return jsonEncode(payload);
  }

  void clearForm() {
    pacienteController.clear();
    avaliadorController.clear();
    dataController.clear();
    equipamentoController.clear();
    for (var data in muscleDataMap.values) {
      data.reobaseDireito.clear();
      data.acomodacaoDireito.clear();
      data.cronaxiaDireito.clear();
      data.reobaseEsquerdo.clear();
      data.acomodacaoEsquerdo.clear();
      data.cronaxiaEsquerdo.clear();
      data.observacoesController.clear();
    }
    notifyListeners();
  }
}
