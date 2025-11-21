import 'package:flutter/material.dart';
import 'package:projeto/Core/Constants/appStrings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text(AppStrings.formAsia),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/asia_form');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text(AppStrings.formGas),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/gas_form');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text(AppStrings.formAnmenese),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/anmenese_form');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("MEEM"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/meem_form');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Eletrodiagnóstico"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/eletro_form');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Dex"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dex_form');
            },
          ),
        ],
      ),
    );
  }
}
