import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Presentation/Screens/pacienteSearch.dart';

class PatientSelectionScreen extends StatelessWidget {
  const PatientSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: AppColors.emerald),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40.0,
                horizontal: 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Selecionar Paciente",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildBigButton(
                    context,
                    "Cadastrar\nPaciente",
                    () => Navigator.pushNamed(context, '/pacienteCadastro'),
                  ),

                  const SizedBox(height: 24),

                  _buildBigButton(context, "Buscar\nPaciente", () {
                    showDialog(
                      context: context,
                      builder: (context) => const PatientSearchDialog(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBigButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 200,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
