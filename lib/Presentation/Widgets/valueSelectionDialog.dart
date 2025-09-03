import 'package:flutter/material.dart';
import 'package:projeto/Core/Models/neurologyCellData.dart';

class ValueSelectionDialog extends StatelessWidget {
  final String? currentValue;
  final CellType cellType;

  const ValueSelectionDialog({
    super.key,
    this.currentValue,
    required this.cellType,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> values = ['0', '1', '2', '3', '4', '5', 'NT'];

    return AlertDialog(
      title: const Text('Selecionar Valor'),
      content: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: values.map((value) {
          bool isNormalMotorScore = value == '5';
          bool canBeStarred = !isNormalMotorScore;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ValueButton(
                value: value,
                onTap: (val) => Navigator.of(context).pop(val),
                isSelected: currentValue == value,
                isNormalMotorScore: isNormalMotorScore,
              ),
              if (canBeStarred)
                _ValueButton(
                  value: '$value*',
                  onTap: (val) => Navigator.of(context).pop(val),
                  isSelected: currentValue == '$value*',
                  isFlag: true,
                ),
            ],
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Retorna null
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

// Widget interno para o botão de valor
class _ValueButton extends StatelessWidget {
  final String value;
  final ValueChanged<String> onTap;
  final bool isSelected;
  final bool isNormalMotorScore; // Indica se é a pontuação 5 (não tem *)
  final bool isFlag; // Indica se é um valor com *

  const _ValueButton({
    required this.value,
    required this.onTap,
    this.isSelected = false,
    this.isNormalMotorScore = false,
    this.isFlag = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        width: 45,
        height: 45,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : Colors.grey.shade200,
          border: Border.all(
            color: Colors.grey.shade400,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isFlag ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}
