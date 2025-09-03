import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Models/neurologyCellData.dart';
import 'package:projeto/Presentation/Widgets/interactiveAsia.dart';

// 1. Convertido para StatefulWidget para controlar o estado (aberto/fechado)
class MotorInputCard extends StatefulWidget {
  final Side side;
  final List<NeurologyCellData> motorCellsForSide;
  final Function(String id, String? value) onCellValueChanged;

  const MotorInputCard({
    super.key,
    required this.side,
    required this.motorCellsForSide,
    required this.onCellValueChanged,
  });

  @override
  State<MotorInputCard> createState() => _MotorInputCardState();
}

class _MotorInputCardState extends State<MotorInputCard> {
  // 2. Variável de estado para controlar se o card está expandido. `false` = começa fechado.
  bool _isExpanded = false;

  NeurologyCellData? _getCellForLevel(String level) {
    return widget.motorCellsForSide.firstWhere((cell) => cell.level == level);
  }

  @override
  Widget build(BuildContext context) {
    final String sideLabel = widget.side == Side.right ? "Direito" : "Esquerdo";

    return Card(
      color: AppColors.emerald,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      elevation: 2.0,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          // 3. Adicionado um ícone ao título usando um Row
          title: Row(
            children: [
              Text(
                'Motor - Lado $sideLabel',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          // 4. `initiallyExpanded` agora usa a variável de estado
          initiallyExpanded: _isExpanded,
          // 5. onExpansionChanged atualiza o estado quando o usuário clica
          onExpansionChanged: (expanding) {
            setState(() {
              _isExpanded = expanding;
            });
          },
          // 6. O ícone de expandir/recolher agora é visível e muda de acordo com o estado
          trailing: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.white,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: AppStrings.motorLevels.map((level) {
                  final cell = _getCellForLevel(level);
                  if (cell == null) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                level,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                AppStrings.motorHelpers[level] ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: InteractiveAsiaCell(
                            cellData: cell,
                            onCellValueChanged: widget.onCellValueChanged,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper para firstWhere orElse
extension IterableExtension<T> on Iterable<T> {
  T? firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    for (var element in this) {
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();
    throw StateError('No element satisfies the test');
  }
}
