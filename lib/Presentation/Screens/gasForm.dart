import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Models/GoalsModels.dart';
import 'package:projeto/Core/Services/api_service.dart';
import 'package:projeto/Presentation/CommonWidgets/appDrawer.dart';

class GasForm extends StatefulWidget {
  const GasForm({super.key});

  @override
  State<GasForm> createState() => _GasFormState();
}

class _GasFormState extends State<GasForm> {
  final _formKey = GlobalKey<FormState>();

  final _interventionPlanController = TextEditingController();
  final _iqController = TextEditingController();
  final _planningDateController = TextEditingController();
  final _revaluationDateController = TextEditingController();

  DateTime? _planningDate;
  DateTime? _revaluationDate;
  List<Goal> _goals = [];
  bool _isLoading = false;

  double _gasScoreBase = 0.0;
  double _gasScoreAchieved = 0.0;
  double _evolution = 0.0;
  double _somatorioP1 = 0.0;
  double _somatorioP2 = 0.0;
  double _somatorioP3 = 0.0;
  double _somatorioP4 = 0.0;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initializeGoals();
    _calculateAll();
  }

  void _calculateAll() {
    double sumP1 = 0;
    double sumP2 = 0;
    double sumP3 = 0;
    double sumP4 = 0;

    for (var goal in _goals) {
      sumP1 += goal.ponderation1;
      sumP2 += goal.ponderation2;
      sumP3 += goal.ponderation3;
      sumP4 += goal.ponderation4;
    }

    double gasScoreBaseResult = 0.0;
    double gasScoreAchievedResult = 0.0;

    if (sumP2 > 0) {
      final denominator = sqrt(sumP2);
      gasScoreBaseResult = 50.0 + (10 * sumP3) / denominator;
      gasScoreAchievedResult = 50.0 + (10 * sumP4) / denominator;
    }

    setState(() {
      _somatorioP1 = sumP1;
      _somatorioP2 = sumP2;
      _somatorioP3 = sumP3;
      _somatorioP4 = sumP4;
      _gasScoreBase = gasScoreBaseResult;
      _gasScoreAchieved = gasScoreAchievedResult;
      _evolution = gasScoreAchievedResult - gasScoreBaseResult;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha o nome do paciente no campo indicado.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _apiService.submitGasEvaluation(
        patientIdentifier: _interventionPlanController.text,
        planningDate: _planningDate,
        revaluationDate: _revaluationDate,
        interventionPlan: _interventionPlanController.text,
        iq: _iqController.text,
        goals: _goals,
      );

      final summary = result['summary'];
      setState(() {
        _gasScoreBase = summary['gasScoreBase'];
        _gasScoreAchieved = summary['gasScoreAchieved'];
        _evolution = summary['evolution'];
        _somatorioP1 = summary['somatorioP1'];
        _somatorioP2 = summary['somatorioP2'];
        _somatorioP3 = summary['somatorioP3'];
        _somatorioP4 = summary['somatorioP4'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Avaliação salva com sucesso! Score Alcançado: ${result['summary']['gasScoreAchieved'].toStringAsFixed(2)}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _initializeGoals() {
    setState(() {
      _goals = [
        Goal(
          id: 0,
          mainCategory: '',
          secundaryCategory: AppStrings.secundaryCategory0,
          initialDescription: '',
        ),
        Goal(
          id: 1,
          mainCategory: AppStrings.mainCategory1,
          secundaryCategory: AppStrings.secundaryCategory1,
          initialDescription: '',
        ),
        Goal(
          id: 2,
          mainCategory: AppStrings.mainCategory1,
          secundaryCategory: AppStrings.secundaryCategory2,
          initialDescription: '',
        ),
        Goal(
          id: 3,
          mainCategory: AppStrings.mainCategory1,
          secundaryCategory: AppStrings.secundaryCategory3,
          initialDescription: '',
        ),
        Goal(
          id: 4,
          mainCategory: AppStrings.mainCategory1,
          secundaryCategory: AppStrings.secundaryCategory4,
          initialDescription: '',
        ),
        Goal(
          id: 5,
          mainCategory: AppStrings.mainCategory1,
          secundaryCategory: AppStrings.secundaryCategory5,
          initialDescription: '',
        ),
        Goal(
          id: 6,
          mainCategory: AppStrings.mainCategory1,
          secundaryCategory: AppStrings.secundaryCategory6,
          initialDescription: '',
        ),
        Goal(
          id: 7,
          mainCategory: AppStrings.mainCategory2,
          secundaryCategory: AppStrings.secundaryCategory7,
          initialDescription: '',
        ),
        Goal(
          id: 8,
          mainCategory: AppStrings.mainCategory2,
          secundaryCategory: AppStrings.secundaryCategory8,
          initialDescription: '',
        ),
        Goal(
          id: 9,
          mainCategory: AppStrings.mainCategory2,
          secundaryCategory: AppStrings.secundaryCategory9,
          initialDescription: '',
        ),
        Goal(
          id: 10,
          mainCategory: AppStrings.mainCategory2,
          secundaryCategory: AppStrings.secundaryCategory10,
          initialDescription: '',
        ),
        Goal(
          id: 11,
          mainCategory: AppStrings.mainCategory2,
          secundaryCategory: AppStrings.secundaryCategory11,
          initialDescription: '',
        ),
        Goal(
          id: 12,
          mainCategory: '',
          secundaryCategory: AppStrings.secundaryCategory12,
          initialDescription: '',
        ),
      ];
    });
  }

  @override
  void dispose() {
    _interventionPlanController.dispose();
    _iqController.dispose();
    _planningDateController.dispose();
    _revaluationDateController.dispose();
    for (var goal in _goals) {
      goal.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(AppStrings.gasFormTitle0),
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
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _submitForm,
        label: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Salvar Avaliação',
                style: TextStyle(color: Colors.white),
              ),
        icon: const Icon(Icons.save, color: Colors.white),
        backgroundColor: AppColors.emerald,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.gasFormTitle1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildHeaderCard(context)),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildTableCaption()),
                  ],
                ),
                const SizedBox(height: 24),
                _buildGoalsList(),
                const SizedBox(height: 24),
                _buildSummaryTable(),
                const SizedBox(height: 24),
                _buildSumTable(),
                const SizedBox(height: 24),
                _buildSummarySection(),
                const SizedBox(height: 24),
                Text(
                  AppStrings.gasFormTitle2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                _buildGoalDescriptionList(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      color: AppColors.emerald,
      elevation: 4,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            TextFormField(
              controller: _planningDateController,

              readOnly: true,

              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: 'Data do planejamento',
                labelStyle: TextStyle(color: Colors.white),

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),

                prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
              ),

              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,

                  initialDate: _planningDate ?? DateTime.now(),

                  firstDate: DateTime(2000),

                  lastDate: DateTime(2101),

                  locale: const Locale('pt', 'BR'),
                );

                if (pickedDate != null) {
                  setState(() {
                    _planningDate = pickedDate;

                    _planningDateController.text = DateFormat(
                      'dd/MM/yyyy',
                    ).format(pickedDate);
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _interventionPlanController,
              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: 'Plano de intervenção do cliente',
                labelStyle: TextStyle(color: Colors.white),

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),

                prefixIcon: Icon(Icons.person, color: Colors.white),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o identificador do paciente.';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _revaluationDateController,

              readOnly: true,

              style: TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: 'Data para reavaliação',
                labelStyle: TextStyle(color: Colors.white),

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(Icons.event_repeat, color: Colors.white),
              ),

              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,

                  initialDate: _revaluationDate ?? DateTime.now(),

                  firstDate: DateTime(2000),

                  lastDate: DateTime(2101),

                  locale: const Locale('pt', 'BR'),
                );

                if (pickedDate != null) {
                  setState(() {
                    _revaluationDate = pickedDate;

                    _revaluationDateController.text = DateFormat(
                      'dd/MM/yyyy',
                    ).format(pickedDate);
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _iqController,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'IQ',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCaption() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(color: AppColors.emerald),
            child: const Center(
              child: Text(
                AppStrings.captionTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Table(
            border: TableBorder.all(color: Colors.white),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: [
              _buildTableRow(['0', AppStrings.captionZero]),
              _buildTableRow(['1', AppStrings.captionOne]),
              _buildTableRow(['2', AppStrings.captionTwo]),
              _buildTableRow(['3', AppStrings.captionThree]),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells) {
    return TableRow(
      decoration: BoxDecoration(color: AppColors.emerald),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Center(
            child: Text(
              cell,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGoalsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _goals.length,
      itemBuilder: (context, index) {
        final goal = _goals[index];
        return _buildGoalExpansionCard(goal);
      },
    );
  }

  Widget _buildGoalExpansionCard(Goal goal) {
    return Card(
      color: AppColors.emerald,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        title: Text(
          '${goal.secundaryCategory} - ${goal.id}',
          style: TextStyle(color: Colors.white),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInnerTableHeader(),
                _buildInnerTableDataRow(goal),
                const Divider(height: 24, thickness: 1, color: Colors.white),
                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledTextField(
                        'Linha de Base',
                        goal.baselineController,
                        (val) => setState(() => goal.baseline = val),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildLabeledTextField(
                        'Alcançado',
                        goal.achievedController,
                        (val) => setState(() => goal.achieved = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerTableHeader() {
    final headerStyle = TextStyle(color: Colors.white, fontSize: 12);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Descrição da meta', style: headerStyle),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text('Importância', style: headerStyle)),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text('Dificuldade', style: headerStyle)),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerTableDataRow(Goal goal) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              cursorColor: Colors.white,
              controller: goal.descriptionController,
              maxLines: null,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: DropdownButtonFormField<int>(
              dropdownColor: AppColors.greenSecundary,
              iconEnabledColor: Colors.white,
              value: goal.importance,
              items: [0, 1, 2, 3]
                  .map(
                    (v) => DropdownMenuItem<int>(
                      value: v,
                      child: Center(child: Text(v.toString())),
                    ),
                  )
                  .toList(),
              style: TextStyle(color: Colors.white),
              onChanged: (val) {
                setState(() => goal.importance = val ?? 0);
                _calculateAll();
              },
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: DropdownButtonFormField<int>(
              dropdownColor: AppColors.greenSecundary,
              iconEnabledColor: Colors.white,
              value: goal.difficulty,
              items: [0, 1, 2, 3]
                  .map(
                    (v) => DropdownMenuItem<int>(
                      value: v,
                      child: Center(child: Text(v.toString())),
                    ),
                  )
                  .toList(),
              style: TextStyle(color: Colors.white),
              onChanged: (val) {
                setState(() => goal.difficulty = val ?? 0);
                _calculateAll();
              },
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledTextField(
    String label,
    TextEditingController controller,
    ValueChanged<double?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
        const SizedBox(height: 4),
        TextFormField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          onChanged: (text) {
            onChanged(double.tryParse(text));
            _calculateAll();
          },
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Card(
      elevation: 4,
      color: AppColors.emerald,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text(
                  'Fator Probabilístico',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  _somatorioP2.toStringAsFixed(1),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  '√ Fator Probabilístico',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  _somatorioP2 > 0
                      ? sqrt(_somatorioP2).toStringAsFixed(2)
                      : '0.0',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            Container(width: 1, height: 120, color: Colors.grey.shade300),
            Column(
              children: [
                const Text(
                  'GAS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                _buildGasScoreRow(
                  'Linha de Base',
                  _gasScoreBase.toStringAsFixed(2),
                ),
                _buildGasScoreRow(
                  'Alcançado',
                  _gasScoreAchieved.toStringAsFixed(2),
                ),
                const Divider(),
                _buildGasScoreRow('Evolução', _evolution.toStringAsFixed(2)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGasScoreRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSumTable() {
    const cellTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Card(
      color: AppColors.emerald,
      clipBehavior: Clip.antiAlias,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.2),
        ),
        columns: const [
          DataColumn(label: Text('Ponderação', style: cellTextStyle)),
          DataColumn(label: Text('(Ponderação)²', style: cellTextStyle)),
          DataColumn(label: Text('Ponderada', style: cellTextStyle)),
          DataColumn(label: Text('Ponderado', style: cellTextStyle)),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
                Center(
                  child: Text(
                    _somatorioP1.toStringAsFixed(1),
                    style: cellTextStyle,
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Text(
                    _somatorioP2.toStringAsFixed(1),
                    style: cellTextStyle,
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Text(
                    _somatorioP3.toStringAsFixed(1),
                    style: cellTextStyle,
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Text(
                    _somatorioP4.toStringAsFixed(1),
                    style: cellTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTable() {
    return Card(
      color: AppColors.emerald,
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(AppColors.emerald),
          columns: const [
            DataColumn(
              label: Text(
                'Meta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Importância',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Dificuldade',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Ponderação',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                '(Ponderação)²',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Linha de Base',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Ponderada',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Alcançado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Ponderado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          rows: _goals
              .map(
                (goal) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        goal.id.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataCell(
                      Text(
                        goal.importance.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataCell(
                      Text(
                        goal.difficulty.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataCell(
                      Text(
                        goal.ponderation1.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        goal.ponderation2.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        goal.baseline?.toString() ?? '',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataCell(
                      Text(
                        goal.ponderation3.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        goal.achieved?.toString() ?? '',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataCell(
                      Text(
                        goal.ponderation4.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildGoalDescriptionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _goals.length,
      itemBuilder: (context, index) {
        final goal = _goals[index];
        return Card(
          color: AppColors.emerald,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildGoalDescriptionTile(goal),
        );
      },
    );
  }

  Widget _buildGoalDescriptionTile(Goal goal) {
    return ExpansionTile(
      collapsedIconColor: Colors.white,
      iconColor: Colors.white,
      title: ValueListenableBuilder<TextEditingValue>(
        valueListenable: goal.descriptionController,
        builder: (context, value, child) {
          final description = value.text.isNotEmpty
              ? value.text
              : goal.secundaryCategory;
          return Text(
            'Meta ${goal.id}: $description',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            children: [
              _buildDescriptionTextField(
                goal.levelMinus2Controller,
                '-2 (Piora)',
              ),
              const SizedBox(height: 12),
              _buildDescriptionTextField(
                goal.levelMinus1Controller,
                '-1 (Linha de Base)',
              ),
              const SizedBox(height: 12),
              _buildDescriptionTextField(goal.level0Controller, '0 (Esperado)'),
              const SizedBox(height: 12),
              _buildDescriptionTextField(
                goal.levelPlus1Controller,
                '1 (Melhor que Esperado)',
              ),
              const SizedBox(height: 12),
              _buildDescriptionTextField(
                goal.levelPlus2Controller,
                '2 (Muito Melhor que Esperado)',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTextField(
    TextEditingController controller,
    String label,
  ) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      maxLines: null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
