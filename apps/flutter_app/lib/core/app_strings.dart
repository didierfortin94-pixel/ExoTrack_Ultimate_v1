import 'package:flutter/widgets.dart';

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  bool get _fr => locale.languageCode.startsWith('fr');

  String get appTitle => 'CoachPulse';
  String get today => _fr ? 'Aujourd’hui' : 'Today';
  String get email => _fr ? 'Courriel' : 'Email';
  String get password => _fr ? 'Mot de passe' : 'Password';
  String get login => _fr ? 'Connexion' : 'Login';
  String get sessionOfDay => _fr ? 'Séance du jour' : 'Session of the day';
  String get completeSession => _fr ? 'Terminer la séance' : 'Complete session';
}

AppStrings stringsOf(BuildContext context) {
  final locale = Localizations.localeOf(context);
  return AppStrings(locale);
}
