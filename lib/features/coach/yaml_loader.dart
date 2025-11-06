
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

class SportRuleSet { final Map data; SportRuleSet(this.data); }

class CoachYamlLoader {
  Future<SportRuleSet> load(String sport) async {
    final raw = await rootBundle.loadString('assets/data/rules/'+sport+'.yaml');
    final map = loadYaml(raw) as YamlMap;
    return SportRuleSet(json.decode(json.encode(map)));
  }
}
