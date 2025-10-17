import 'package:flutter/material.dart';
import 'dart:collection';

class MeemFormProvider extends ChangeNotifier {
  // --- Dados do Paciente ---
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  String? escolaridade;

  // --- Variáveis de Pontuação (AGORA COMO INTEIROS) ---
  // Inicializamos todas as pontuações com 0.
  List<int> pontosOrientacaoTemporal = List.filled(5, 0);
  List<int> pontosOrientacaoEspacial = List.filled(5, 0);
  List<int> pontosMemoriaImediata = List.filled(3, 0);
  List<int> pontosAtencaoCalculo = List.filled(5, 0);
  List<int> pontosMemoriaEvocativa = List.filled(3, 0);
  List<int> pontosLinguagemNomear = List.filled(2, 0);
  int pontoLinguagemRepetir = 0;
  List<int> pontosLinguagemComandoVerbal = List.filled(3, 0);
  int pontoLinguagemComandoEscrito = 0;
  int pontoLinguagemFrase = 0;
  int pontoLinguagemCopia = 0;

  // --- Métodos para atualizar o estado ---

  void updateEscolaridade(String? newValue) {
    escolaridade = newValue;
    notifyListeners();
  }

  void updatePontos(List<int> listaDePontos, int index, int value) {
    if (index < listaDePontos.length) {
      listaDePontos[index] = value;
      notifyListeners();
    }
  }

  void updatePontoSimples(int newValue, Function(int) setter) {
    setter(newValue);
    notifyListeners();
  }

  // --- Lógica de Cálculo ---

  int get totalScore {
    int score = 0;
    // Soma os valores de cada lista
    score += pontosOrientacaoTemporal.fold(
      0,
      (prev, element) => prev + element,
    );
    score += pontosOrientacaoEspacial.fold(
      0,
      (prev, element) => prev + element,
    );
    score += pontosMemoriaImediata.fold(0, (prev, element) => prev + element);
    score += pontosAtencaoCalculo.fold(0, (prev, element) => prev + element);
    score += pontosMemoriaEvocativa.fold(0, (prev, element) => prev + element);
    score += pontosLinguagemNomear.fold(0, (prev, element) => prev + element);
    // Soma os pontos individuais
    score += pontoLinguagemRepetir;
    score += pontosLinguagemComandoVerbal.fold(
      0,
      (prev, element) => prev + element,
    );
    score += pontoLinguagemComandoEscrito;
    score += pontoLinguagemFrase;
    score += pontoLinguagemCopia;
    return score;
  }

  String get pontuacaoEsperada {
    if (escolaridade == null) return "N/A (Selecione a escolaridade)";
    switch (escolaridade) {
      case 'Analfabeto':
        return "20 pontos";
      case '1-4 anos':
        return "25 pontos";
      case '5-8 anos':
        return "26 pontos";
      case '9-11 anos':
        return "28 pontos";
      case '12+ anos':
        return "29 pontos";
      default:
        return "N/A";
    }
  }

  // --- Limpeza ---
  @override
  void dispose() {
    nomeController.dispose();
    idadeController.dispose();
    super.dispose();
  }
}
