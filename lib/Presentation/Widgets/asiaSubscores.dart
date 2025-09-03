import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Models/resultsModels.dart';

class AsiaSubscoresSection extends StatelessWidget {
  final IscnsciResult? result;

  const AsiaSubscoresSection({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const SizedBox.shrink();
    }

    final totals = result!.totals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: AppColors.emerald,
          elevation: 4.0,
          margin: const EdgeInsets.only(bottom: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.motorSubscoresTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const Divider(height: 20, thickness: 1.5),
                _buildSubscoreRow(
                  label: AppStrings.uerLabel,
                  value: totals.upperExtremityRight.toString(),
                  maxScore: '25',
                ),
                _buildSubscoreGroupSeparator(),
                _buildSubscoreRow(
                  label: '+ ${AppStrings.uelLabel}',
                  value: totals.upperExtremityLeft.toString(),
                  maxScore: '25',
                ),
                _buildTotalSubscoreRow(
                  label: AppStrings.uemsTotal,
                  value: totals.upperExtremity.toString(),
                  maxScore: '50',
                ),
                const Divider(height: 20, thickness: 1.0),
                _buildSubscoreRow(
                  label: AppStrings.lerLabel,
                  value: totals.lowerExtremityRight.toString(),
                  maxScore: '25',
                ),
                _buildSubscoreGroupSeparator(),
                _buildSubscoreRow(
                  label: '+ ${AppStrings.lelLabel}',
                  value: totals.lowerExtremityLeft.toString(),
                  maxScore: '25',
                ),
                _buildTotalSubscoreRow(
                  label: AppStrings.lemsTotal,
                  value: totals.lowerExtremity.toString(),
                  maxScore: '50',
                ),
              ],
            ),
          ),
        ),
        Card(
          color: AppColors.emerald,
          elevation: 4.0,
          margin: const EdgeInsets.only(bottom: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.sensorySubscoresTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const Divider(height: 20, thickness: 1.5),
                _buildSubscoreRow(
                  label: 'TL Direita',
                  value: totals.lightTouchRight.toString(),
                  maxScore: '56',
                ),
                _buildSubscoreGroupSeparator(),
                _buildSubscoreRow(
                  label: '+ TL Esquerda',
                  value: totals.lightTouchLeft.toString(),
                  maxScore: '56',
                ),
                _buildTotalSubscoreRow(
                  label: AppStrings.ltTotal,
                  value: totals.lightTouch.toString(),
                  maxScore: '112',
                ),
                const Divider(height: 20, thickness: 1.0),
                _buildSubscoreRow(
                  label: 'EA Direita',
                  value: totals.pinPrickRight.toString(),
                  maxScore: '56',
                ),
                _buildSubscoreGroupSeparator(),
                _buildSubscoreRow(
                  label: '+ EA Esquerda',
                  value: totals.pinPrickLeft.toString(),
                  maxScore: '56',
                ),
                _buildTotalSubscoreRow(
                  label: AppStrings.ppTotal,
                  value: totals.pinPrick.toString(),
                  maxScore: '112',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscoreRow({
    required String label,
    required String value,
    required String maxScore,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildValueContainer(value),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${AppStrings.maximumLabel} ($maxScore)',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSubscoreRow({
    required String label,
    required String value,
    required String maxScore,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildValueContainer(value, isTotal: true),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${AppStrings.maximumLabel} ($maxScore)',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueContainer(String value, {bool isTotal = false}) {
    return Container(
      width: 45,
      height: 35,
      decoration: BoxDecoration(
        color: isTotal ? Colors.blue.shade50 : Colors.grey.shade100,
        border: Border.all(color: isTotal ? Colors.blue : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: TextStyle(
          fontWeight: isTotal ? FontWeight.bold : FontWeight.bold,
          fontSize: 17,
          color: isTotal ? Colors.blue.shade800 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSubscoreGroupSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '+',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
