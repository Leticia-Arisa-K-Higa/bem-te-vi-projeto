import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projeto/Core/Constants/appStrings.dart';
import 'package:projeto/Core/Providers/asiaFormProvider.dart';
import 'package:projeto/Presentation/Screens/anmeneseForm.dart';
import 'package:projeto/Presentation/Screens/asiaForm.dart';
import 'package:projeto/Presentation/Screens/gasForm.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AsiaFormProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: ThemeData(
          fontFamily: 'Inter',
          primaryColor: AppColors.emerald,
          scaffoldBackgroundColor: AppColors.background,

          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.grey.shade600),
            filled: false,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.emerald, width: 2.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4.0,
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emerald,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),

          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppColors.emerald,
            headerForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.emerald,
            primary: AppColors.emerald,
            background: AppColors.background,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        home: const AsiaForm(),
        routes: {
          '/asia_form': (context) => const AsiaForm(),
          '/gas_form': (context) => const GasForm(),
          '/anmenese_form': (context) => const AnmeneseForm(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
