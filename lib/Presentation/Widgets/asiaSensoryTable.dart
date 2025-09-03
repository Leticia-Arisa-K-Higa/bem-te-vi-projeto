import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Models/neurologyCellData.dart';
import 'package:projeto/Presentation/Widgets/interactiveAsia.dart';

class AsiaMotorSensoryTable extends StatelessWidget {
  final Side side;
  final List<NeurologyCellData> cells;
  final Function(String id, String? value) onCellValueChanged;

  const AsiaMotorSensoryTable({
    super.key,
    required this.side,
    required this.cells,
    required this.onCellValueChanged,
  });

  NeurologyCellData? _getCell(String level, CellType type) {
    return cells.firstWhereOrNull((c) => c.level == level && c.type == type);
  }

  TableRow _buildSensoryRow(String level) {
    NeurologyCellData? lightTouchCell = _getCell(
      level,
      CellType.sensoryLightTouch,
    );
    NeurologyCellData? pinPrickCell = _getCell(level, CellType.sensoryPinPrick);

    return TableRow(
      children: side == Side.right
          ? [
              TableCell(child: Container()),
              TableCell(child: Container()),
              TableCell(child: Center(child: Text(level))),
              lightTouchCell != null
                  ? InteractiveAsiaCell(
                      cellData: lightTouchCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              pinPrickCell != null
                  ? InteractiveAsiaCell(
                      cellData: pinPrickCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
            ]
          : [
              lightTouchCell != null
                  ? InteractiveAsiaCell(
                      cellData: lightTouchCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              pinPrickCell != null
                  ? InteractiveAsiaCell(
                      cellData: pinPrickCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              TableCell(child: Center(child: Text(level))),
              TableCell(child: Container()),
              TableCell(child: Container()),
            ],
    );
  }

  TableRow _buildMotorAndSensoryRow(String level) {
    final NeurologyCellData? motorCell = _getCell(level, CellType.motor);
    final NeurologyCellData? lightTouchCell = _getCell(
      level,
      CellType.sensoryLightTouch,
    );
    final NeurologyCellData? pinPrickCell = _getCell(
      level,
      CellType.sensoryPinPrick,
    );

    return TableRow(
      children: side == Side.right
          ? [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(AppStrings.motorHelpers[level] ?? ''),
                ),
              ),
              TableCell(child: Center(child: Text(level))),
              motorCell != null
                  ? InteractiveAsiaCell(
                      cellData: motorCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              lightTouchCell != null
                  ? InteractiveAsiaCell(
                      cellData: lightTouchCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              pinPrickCell != null
                  ? InteractiveAsiaCell(
                      cellData: pinPrickCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
            ]
          : [
              lightTouchCell != null
                  ? InteractiveAsiaCell(
                      cellData: lightTouchCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              pinPrickCell != null
                  ? InteractiveAsiaCell(
                      cellData: pinPrickCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              motorCell != null
                  ? InteractiveAsiaCell(
                      cellData: motorCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              TableCell(child: Center(child: Text(level))),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(AppStrings.motorHelpers[level] ?? ''),
                ),
              ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: side == Side.right
          ? const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            }
          : const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(2),
            },
      children: [
        TableRow(
          children: side == Side.right
              ? [
                  TableCell(child: Container()),
                  TableCell(child: Container()),
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          AppStrings.motorLabel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          AppStrings.sensoryLabel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(child: Container()),
                ]
              : [
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          AppStrings.sensoryLabel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(child: Container()),
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          AppStrings.motorLabel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(child: Container()),
                  TableCell(child: Container()),
                ],
        ),
        TableRow(
          children: side == Side.right
              ? [
                  TableCell(child: Container()),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.keyMusclesLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.keySensoryPointsLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.lightTouchLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.pinPrickLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]
              : [
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.lightTouchLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.pinPrickLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.keyMusclesLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.keySensoryPointsLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(child: Container()),
                ],
        ),
        ...AppStrings.sensoryLevels
            .where(
              (level) =>
                  !AppStrings.motorLevels.contains(level) && level != 'S4-5',
            )
            .map((level) => _buildSensoryRow(level))
            .toList(),
        ...AppStrings.motorLevels
            .map((level) => _buildMotorAndSensoryRow(level))
            .toList(),
        _buildSensoryRow('S4-5'),
      ],
    );
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
