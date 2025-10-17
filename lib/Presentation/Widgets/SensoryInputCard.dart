import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Models/neurologyCellData.dart';
import 'package:projeto/Presentation/Widgets/interactiveAsia.dart';

class SensoryInputCard extends StatefulWidget {
  final String level;
  final NeurologyCellData? rightLightTouchCell;
  final NeurologyCellData? rightPinPrickCell;
  final NeurologyCellData? leftLightTouchCell;
  final NeurologyCellData? leftPinPrickCell;
  final Function(String id, String? value) onCellValueChanged;

  const SensoryInputCard({
    super.key,
    required this.level,
    this.rightLightTouchCell,
    this.rightPinPrickCell,
    this.leftLightTouchCell,
    this.leftPinPrickCell,
    required this.onCellValueChanged,
  });

  @override
  State<SensoryInputCard> createState() => _SensoryInputCardState();
}

class _SensoryInputCardState extends State<SensoryInputCard> {
  bool _isExpanded = false;

  // Função que constrói o widget de imagem
  Widget _buildContextualImages() {
    List<String> imagePaths = [];

    if (['C6', 'C7', 'C8'].contains(widget.level)) {
      imagePaths.add('assets/images/asia-hands.png');
    } else if (['C2', 'C3', 'C4'].contains(widget.level)) {
      imagePaths.add('assets/images/asia-head.png');
      imagePaths.add('assets/images/asia-head2.png');
    } else if (widget.level.startsWith('S')) {
      imagePaths.add('assets/images/asia-sacral.png');
    } else {
      imagePaths.add('assets/images/asia-man.png');
    }

    if (imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget imageWidget;
    if (imagePaths.length > 1) {
      imageWidget = Container(
        height: 300,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: imagePaths
                .map(
                  (path) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(path, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(imagePaths.first),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: imageWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.emerald,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            'Sensorial - Nível ${widget.level}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          onExpansionChanged: (expanding) {
            setState(() {
              _isExpanded = expanding;
            });
          },
          initiallyExpanded: _isExpanded,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Lado',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            AppStrings.lightTouchLabel,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            AppStrings.pinPrickLabel,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          AppStrings.rightSideLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: widget.rightLightTouchCell != null
                            ? InteractiveAsiaCell(
                                cellData: widget.rightLightTouchCell!,
                                onCellValueChanged: widget.onCellValueChanged,
                              )
                            : Container(),
                      ),
                      Expanded(
                        flex: 3,
                        child: widget.rightPinPrickCell != null
                            ? InteractiveAsiaCell(
                                cellData: widget.rightPinPrickCell!,
                                onCellValueChanged: widget.onCellValueChanged,
                              )
                            : Container(),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          AppStrings.leftSideLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: widget.leftLightTouchCell != null
                            ? InteractiveAsiaCell(
                                cellData: widget.leftLightTouchCell!,
                                onCellValueChanged: widget.onCellValueChanged,
                              )
                            : Container(),
                      ),
                      Expanded(
                        flex: 3,
                        child: widget.leftPinPrickCell != null
                            ? InteractiveAsiaCell(
                                cellData: widget.leftPinPrickCell!,
                                onCellValueChanged: widget.onCellValueChanged,
                              )
                            : Container(),
                      ),
                    ],
                  ),

                  if (_isExpanded) _buildContextualImages(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
