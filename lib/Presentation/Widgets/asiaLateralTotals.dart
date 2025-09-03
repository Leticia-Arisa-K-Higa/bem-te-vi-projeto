import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Models/resultsModels.dart';

class AsiaLateralTotalsSection extends StatelessWidget {
  final IscnsciResult? result;

  const AsiaLateralTotalsSection({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Card(
        color: AppColors.emerald,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              "Preencha o formulário para ver os totais.",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    final totals = result!.totals;

    return Card(
      color: AppColors.emerald,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Totais Laterais do Exame',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 20, thickness: 1.5),
            const SizedBox(height: 10),
            _buildTotalsTable(
              context,
              label: AppStrings.totalsLabelRight,
              motorValue: totals.rightMotor.toString(),
              lightTouchValue: totals.lightTouchRight.toString(),
              pinPrickValue: totals.pinPrickRight.toString(),
              motorMax: '50',
              sensoryMax: '56',
              isLeft: false,
            ),
            const SizedBox(height: 20),
            _buildTotalsTable(
              context,
              label: AppStrings.totalsLabelLeft,
              motorValue: totals.leftMotor.toString(),
              lightTouchValue: totals.lightTouchLeft.toString(),
              pinPrickValue: totals.pinPrickLeft.toString(),
              motorMax: '50',
              sensoryMax: '56',
              isLeft: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsTable(
    BuildContext context, {
    required String label,
    required String motorValue,
    required String lightTouchValue,
    required String pinPrickValue,
    required String motorMax,
    required String sensoryMax,
    required bool isLeft,
  }) {
    final List<Widget> topRowCells = isLeft
        ? [
            _buildValueBox(lightTouchValue),
            _buildValueBox(pinPrickValue),
            _buildValueBox(motorValue),
          ]
        : [
            _buildValueBox(motorValue),
            _buildValueBox(lightTouchValue),
            _buildValueBox(pinPrickValue),
          ];

    final List<Widget> bottomRowCells = isLeft
        ? [
            Text('($sensoryMax)'),
            Text('($sensoryMax)'),
            Text('($motorMax)', style: TextStyle(color: Colors.white)),
          ]
        : [
            Text('($motorMax)'),
            Text('($sensoryMax)'),
            Text('($sensoryMax)', style: TextStyle(color: Colors.white)),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: isLeft ? 0 : 8.0,
            right: isLeft ? 8.0 : 0,
            bottom: 4.0,
          ),
          child: Align(
            alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: topRowCells
                  .map((widget) => TableCell(child: Center(child: widget)))
                  .toList(),
            ),
            TableRow(
              children: bottomRowCells
                  .map(
                    (widget) => TableCell(
                      child: Center(
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                          child: widget,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildValueBox(String value) {
    return Container(
      width: 55,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
