import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Models/resultsModels.dart';

class AsiaTotalsSection extends StatelessWidget {
  final IscnsciResult? result;

  const AsiaTotalsSection({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Card(
        color: AppColors.emerald,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              "Preencha o formulário para ver a classificação.",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    final classification = result!.classification;

    return Card(
      color: AppColors.emerald,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBlockHeader(
              context,
              AppStrings.neurologicalLevelsTitle,
              helper: AppStrings.neurologicalLevelsHelper,
            ),
            Table(
              border: TableBorder.all(color: Colors.white),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.white),
                  children: const [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Direita',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Esquerda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          AppStrings.sensoryTotalStep,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          classification.neurologicalLevels.sensoryRight,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          classification.neurologicalLevels.sensoryLeft,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          AppStrings.motorTotalStep,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          classification.neurologicalLevels.motorRight,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          classification.neurologicalLevels.motorLeft,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTotalInfoRow(
              context,
              label: AppStrings.nliTitle,
              value: classification.neurologicalLevelOfInjury,
              isLargerBox: true,
            ),
            const SizedBox(height: 16),
            _buildTotalInfoRow(
              context,
              label: AppStrings.completenessTitle,
              helper: AppStrings.completenessHelper,
              value: classification.injuryComplete,
              isLargerBox: true,
            ),
            const SizedBox(height: 8),
            _buildTotalInfoRow(
              context,
              label: AppStrings.aisTitle,
              value: classification.asiaImpairmentScale,
              isLargerBox: true,
            ),
            const SizedBox(height: 16),
            _buildBlockHeader(
              context,
              AppStrings.zppTitle,
              helper: AppStrings.zppHelper,
            ),
            Table(
              border: TableBorder.all(color: Colors.white),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.white),
                  children: const [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Direita',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Esquerda',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Sensorial',
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          classification
                              .zoneOfPartialPreservations
                              .sensoryRight,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          classification.zoneOfPartialPreservations.sensoryLeft,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Motor',
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          classification.zoneOfPartialPreservations.motorRight,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          classification.zoneOfPartialPreservations.motorLeft,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockHeader(
    BuildContext context,
    String title, {
    String? helper,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        if (helper != null)
          Text(
            helper,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTotalInfoRow(
    BuildContext context, {
    required String label,
    String? helper,
    required String value,
    bool isLargerBox = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 320;
        final double boxWidth = isLargerBox ? 90 : 80;
        final double boxHeight = isLargerBox ? 60 : 50;
        final double valueFontSize = isLargerBox ? 14 : 12;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: isCompact ? 3 : 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  if (helper != null)
                    Padding(
                      padding: EdgeInsets.only(top: isCompact ? 2.0 : 0.0),
                      child: Text(
                        helper,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: boxWidth,
              height: boxHeight,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade50,
              ),
              alignment: Alignment.center,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: valueFontSize,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
