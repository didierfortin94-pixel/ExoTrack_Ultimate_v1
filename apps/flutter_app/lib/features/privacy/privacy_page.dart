import 'dart:convert';

import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confidentialité & Mentions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Export JSON'),
            subtitle: Text('Exporte les données utilisateur en JSON.'),
          ),
          FilledButton(
            onPressed: () {
              final payload = jsonEncode({'status': 'export-ready'});
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(payload)));
            },
            child: const Text('Exporter mes données'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Supprimer mon compte (soft delete)'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Avertissement: CoachPulse est un outil de coaching et ne constitue pas un dispositif médical.',
          ),
        ],
      ),
    );
  }
}
