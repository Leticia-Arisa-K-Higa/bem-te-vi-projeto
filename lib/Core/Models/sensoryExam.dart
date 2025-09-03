// Enumeração para o tipo de teste da célula
import 'package:projeto/Core/Models/neurologyCellData.dart';

// Dados de uma única célula no formulário ASIA
class SensoryExam {
  // Identificador único para a célula
  final String id;

  // Valor atual da célula
  String? value;

  // Tipo de teste que a célula representa
  final CellType type;

  // O lado do corpo ao qual a célula pertence
  final Side side;

  // O nível neurológico associado a esta célula
  final String level;

  // Título ou descrição mais detalhada para a célula
  final String title;

  // Construtor para criar uma instância de [SensoryExam]
  SensoryExam({
    required this.id,
    required this.type,
    required this.side,
    required this.level,
    required this.title,
    this.value = 'NT',
  });
}

const List<String> _dermatomeLevels = [
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

// Função para retornar a lista de níveis de dermátomos
List<String> getDermatomeLevels() {
  return _dermatomeLevels;
}

/// Gera a lista inicial de todos os pontos de exame sensorial.
List<SensoryExam> getInitialSensoryData() {
  final List<SensoryExam> exams = [];

  // Itera sobre cada nível de dermátomo
  for (final level in _dermatomeLevels) {
    // Itera sobre cada lado (Direita e Esquerda)
    for (final side in Side.values) {
      final sideString = side == Side.right ? 'Direita' : 'Esquerda';

      // Adiciona o exame de Picada (Pin Prick) para o nível e lado atuais
      exams.add(
        SensoryExam(
          id: '${level}_${side.name}_pinPrick',
          type: CellType.sensoryPinPrick,
          side: side,
          level: level,
          title: 'Picada no nível $level - $sideString',
        ),
      );

      // Adiciona o exame de Toque Leve (Light Touch) para o nível e lado atuais
      exams.add(
        SensoryExam(
          id: '${level}_${side.name}_lightTouch',
          type: CellType.sensoryLightTouch,
          side: side,
          level: level,
          title: 'Toque Leve no nível $level - $sideString',
        ),
      );
    }
  }
  return exams;
}
