import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Models/neurologyCellData.dart';
import 'package:projeto/Core/Models/resultsModels.dart';
import 'package:projeto/Core/Providers/asiaFormProvider.dart';
import 'package:projeto/Core/Services/api_service.dart';
import 'package:projeto/Presentation/CommonWidgets/appDrawer.dart';
import 'package:projeto/Presentation/CommonWidgets/customTextField.dart';
import 'package:projeto/Presentation/Widgets/MotorInputCard.dart';
import 'package:projeto/Presentation/Widgets/SensoryInputCard.dart';
import 'package:projeto/Presentation/Widgets/asiaLateralTotals.dart';
import 'package:projeto/Presentation/Widgets/asiaSensoryTable.dart';
import 'package:projeto/Presentation/Widgets/asiaSubscores.dart';
import 'package:projeto/Presentation/Widgets/asiaTotals.dart';
import 'package:provider/provider.dart';

class AsiaForm extends StatelessWidget {
  const AsiaForm({super.key});

  @override
  Widget build(BuildContext context) {
    final asiaProvider = Provider.of<AsiaFormProvider>(context);

    final motorDireitoCells = asiaProvider.cells
        .where((cell) => cell.type == CellType.motor && cell.side == Side.right)
        .toList();
    final motorEsquerdoCells = asiaProvider.cells
        .where((cell) => cell.type == CellType.motor && cell.side == Side.left)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Menu',
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(AppStrings.asiaFormTitle),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 80, 200, 120),
                Color.fromARGB(255, 6, 190, 123),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.3, 0.9],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Limpar',
            onPressed: () {
              asiaProvider.clearForm();
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Imprimir',
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPatientIdentifierCard(context, asiaProvider),
              const SizedBox(height: 20),
              // --- SEÇÃO SENSORIAL ---
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Avaliação Sensorial',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ...AppStrings.sensoryLevels.map((level) {
                final levelCells = asiaProvider.cells
                    .where((cell) => cell.level == level)
                    .toList();
                return SensoryInputCard(
                  level: level,
                  rightLightTouchCell: levelCells.firstWhereOrNull(
                    (c) =>
                        c.side == Side.right &&
                        c.type == CellType.sensoryLightTouch,
                  ),
                  rightPinPrickCell: levelCells.firstWhereOrNull(
                    (c) =>
                        c.side == Side.right &&
                        c.type == CellType.sensoryPinPrick,
                  ),
                  leftLightTouchCell: levelCells.firstWhereOrNull(
                    (c) =>
                        c.side == Side.left &&
                        c.type == CellType.sensoryLightTouch,
                  ),
                  leftPinPrickCell: levelCells.firstWhereOrNull(
                    (c) =>
                        c.side == Side.left &&
                        c.type == CellType.sensoryPinPrick,
                  ),
                  onCellValueChanged: asiaProvider.updateCellValue,
                );
              }).toList(),
              const SizedBox(height: 20),
              const Divider(thickness: 1, color: Colors.white24),

              // --- SEÇÃO MOTORA ---
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Avaliação Motora',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              MotorInputCard(
                side: Side.right,
                motorCellsForSide: motorDireitoCells,
                onCellValueChanged: asiaProvider.updateCellValue,
              ),
              MotorInputCard(
                side: Side.left,
                motorCellsForSide: motorEsquerdoCells,
                onCellValueChanged: asiaProvider.updateCellValue,
              ),

              const SizedBox(height: 20),
              _buildLowestNonKeyMuscles(context, asiaProvider),
              const SizedBox(height: 20),
              _buildComments(context, asiaProvider),
              const SizedBox(height: 20),
              _buildAnalSensationSelectors(context, asiaProvider),
              const SizedBox(height: 20),
              AsiaLateralTotalsSection(result: asiaProvider.result),
              const SizedBox(height: 20),
              AsiaSubscoresSection(result: asiaProvider.result),
              const SizedBox(height: 20),
              AsiaTotalsSection(result: asiaProvider.result),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 6, 190, 123),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    // 1. Marcamos a função como 'async' para poder esperar a API.

                    // 2. Pegamos uma referência ao provider para acessar os dados.
                    // Usamos 'listen: false' porque estamos dentro de uma função, não construindo a UI.
                    final asiaProvider = Provider.of<AsiaFormProvider>(
                      context,
                      listen: false,
                    );

                    // 3. Usamos o método do provider para empacotar todos os dados do formulário.
                    final examToSubmit = asiaProvider.createExamFromCells();

                    // 4. Criamos uma instância do nosso serviço de API.
                    final apiService = ApiService();

                    try {
                      // 5. Mostramos um diálogo de "carregando" para o usuário saber que algo está acontecendo.
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      // 6. O GRANDE MOMENTO: Enviamos o exame para a API e esperamos ('await') a resposta.
                      final IscnsciResult result = await apiService.submitExam(
                        examToSubmit,
                      );

                      asiaProvider.setFinalResult(result);

                      // 7. Se chegamos aqui, a API funcionou! Primeiro, fechamos o diálogo de "carregando".
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cálculo concluído com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      // 9. Se algo der errado na API (ex: sem internet, servidor Python desligado),
                      // fechamos o "carregando" e mostramos uma mensagem de erro.
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('ERRO AO CALCULAR: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'CALCULAR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 4. O MÉTODO _buildLevelInputCards FOI REMOVIDO.
  //    VOCÊ PODE DELETAR ELE COMPLETAMENTE DO SEU ARQUIVO.

  Widget _buildAnalSensationSelectors(
    BuildContext context,
    AsiaFormProvider provider,
  ) {
    // Este método e os outros abaixo permanecem exatamente iguais.
    return Card(
      color: AppColors.emerald,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sensibilidade Anal',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: provider.voluntaryAnalContraction,
              decoration: const InputDecoration(
                labelText: AppStrings.vacLabel,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: provider.setVoluntaryAnalContraction,
              items: AppStrings.analSensationOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: provider.deepAnalPressure,
              decoration: const InputDecoration(
                labelText: AppStrings.dapLabel,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: provider.setDeepAnalPressure,
              items: AppStrings.analSensationOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowestNonKeyMuscles(
    BuildContext context,
    AsiaFormProvider provider,
  ) {
    final List<DropdownMenuItem<String>> muscleOptions = AppStrings
        .lowestNonKeyMuscleOptions
        .entries
        .map(
          (entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(
              entry.value,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        )
        .toList();

    return Card(
      color: AppColors.emerald,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Músculo não-chave mais baixo com função motora:',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Right:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: DropdownButtonFormField<String>(
                    value: provider.rightLowestNonKeyMuscle,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: provider.setRightLowestNonKeyMuscle,
                    items: muscleOptions,
                    isExpanded: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Left:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: DropdownButtonFormField<String>(
                    value: provider.leftLowestNonKeyMuscle,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: provider.setLeftLowestNonKeyMuscle,
                    items: muscleOptions,
                    isExpanded: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComments(BuildContext context, AsiaFormProvider provider) {
    return Card(
      color: AppColors.emerald,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comentários:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ), // O título já estava correto
            ),
            const SizedBox(height: 8),
            CustomTextField(
              labelText: 'Digite seus comentários aqui...',
              initialValue: provider.comments,
              onChanged: provider.setComments,
              maxLines: 5,
              // 3. PASSANDO AS CORES DESEJADAS
              textColor: Colors.white, // Cor do texto digitado
              labelColor: Colors
                  .white70, // Cor do label (um pouco transparente fica bom)
              cursorColor: Colors.white, // Cor do cursor
              borderColor: Colors.white54, // Cor da borda (também transparente)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientIdentifierCard(
    BuildContext context,
    AsiaFormProvider provider,
  ) {
    return Card(
      color: AppColors.emerald,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Identificação do Paciente',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            // Usando seu CustomTextField para manter o estilo
            CustomTextField(
              labelText: 'Nome ou Prontuário',
              // Conecta o campo de texto ao provider
              onChanged: (value) {
                provider.setPatientIdentifier(value);
              },
              // Define as cores para combinar com o card
              textColor: Colors.white,
              labelColor: Colors.white70,
              cursorColor: Colors.white,
              borderColor: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
