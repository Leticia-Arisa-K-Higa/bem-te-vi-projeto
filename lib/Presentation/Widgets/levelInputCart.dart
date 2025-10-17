import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Models/neurologyCellData.dart';
import 'package:projeto/Presentation/Widgets/MotorInputCard.dart';
import 'package:projeto/Presentation/Widgets/SensoryInputCard.dart';

class LevelInputCard extends StatelessWidget {
  final List<NeurologyCellData> todasAsCelulas;
  final Function(String id, String? value) onCellValueChanged;

  const LevelInputCard({
    super.key,
    required this.todasAsCelulas,
    required this.onCellValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    // --- Lógica para filtrar as células ---

    // Filtra todas as células motoras do lado DIREITO
    final List<NeurologyCellData> motorDireitoCells = todasAsCelulas
        .where((cell) => cell.type == CellType.motor && cell.side == Side.right)
        .toList();

    // Filtra todas as células motoras do lado ESQUERDO
    final List<NeurologyCellData> motorEsquerdoCells = todasAsCelulas
        .where((cell) => cell.type == CellType.motor && cell.side == Side.left)
        .toList();

    // Helper para buscar as células sensoriais de um nível específico
    List<NeurologyCellData> getSensoryCellsForLevel(String level) {
      return todasAsCelulas
          .where((cell) => cell.level == level && cell.type != CellType.motor)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Avaliação Neurológica')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- 1. SEÇÃO SENSORIAL ---
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Avaliação Sensorial',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              // Cria a lista de cards sensoriais, um para cada nível
              ...AppStrings.sensoryLevels.map((level) {
                return SensoryInputCard(
                  level: level,
                  rightLightTouchCell: getSensoryCellsForLevel(level)
                      .firstWhere(
                        (c) =>
                            c.side == Side.right &&
                            c.type == CellType.sensoryLightTouch,
                      ),
                  rightPinPrickCell: getSensoryCellsForLevel(level).firstWhere(
                    (c) =>
                        c.side == Side.right &&
                        c.type == CellType.sensoryPinPrick,
                  ),
                  leftLightTouchCell: getSensoryCellsForLevel(level).firstWhere(
                    (c) =>
                        c.side == Side.left &&
                        c.type == CellType.sensoryLightTouch,
                  ),
                  leftPinPrickCell: getSensoryCellsForLevel(level).firstWhere(
                    (c) =>
                        c.side == Side.left &&
                        c.type == CellType.sensoryPinPrick,
                  ),
                  onCellValueChanged: onCellValueChanged,
                );
              }).toList(),

              const SizedBox(height: 20),
              const Divider(thickness: 2),

              // --- 2. SEÇÃO MOTORA ---
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Avaliação Motora',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              MotorInputCard(
                side: Side.right,
                motorCellsForSide: motorDireitoCells,
                onCellValueChanged: onCellValueChanged,
              ),
              MotorInputCard(
                side: Side.left,
                motorCellsForSide: motorEsquerdoCells,
                onCellValueChanged: onCellValueChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
