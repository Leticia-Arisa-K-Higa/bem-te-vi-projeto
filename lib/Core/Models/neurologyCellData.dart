enum CellType {
  sensoryLightTouch, // Toque leve sensorial
  sensoryPinPrick, // Estímulo com agulha sensorial
  motor, // Motor
}

enum Side {
  right, // Direita
  left, // Esquerda
}

class NeurologyCellData {
  /// Um identificador único para a célula
  final String id;

  /// O valor atual da célula (ex: '0', '1', 'NT', '5*'). Pode ser nulo se não preenchido.
  String? value;

  /// O tipo de teste neurológico que esta célula representa.
  final CellType type;

  /// O lado do corpo ao qual esta célula pertence.
  final Side side;

  /// O nível neurológico (dermátomo/miótomo) associado a esta célula
  final String level;

  /// Texto auxiliar ou descrição para células motoras (ex: 'Flexores do cotovelo'). Pode ser nulo.
  final String? helperText;

  /// Título ou descrição mais detalhada para a célula (usado para tooltips ou diálogos).
  final String title;

  /// Construtor para criar uma instância de [NeurologyCellData].
  NeurologyCellData({
    required this.id,
    this.value,
    required this.type,
    required this.side,
    required this.level,
    this.helperText,
    required this.title,
  });

  /// Cria uma nova instância de [NeurologyCellData] com valores copiados da
  /// instância atual, permitindo a modificação de campos específicos.
  NeurologyCellData copyWith({String? value}) {
    return NeurologyCellData(
      id: id,
      value:
          value ??
          this.value, // Atualiza o valor se fornecido, caso contrário, mantém o atual
      type: type,
      side: side,
      level: level,
      helperText: helperText,
      title: title,
    );
  }
}
