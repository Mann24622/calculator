

import 'package:path/path.dart';

class CalculationHistory {
  final int? id;
  final String equation;
  final String result;


  CalculationHistory({this.id, required this.equation, required this.result,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equation': equation,
      'result': result,

    };
  }

  static CalculationHistory fromMap(Map<String, dynamic> map) {
    return CalculationHistory(
      id: map['id'],
      equation: map['equation'],
      result: map['result'],

    );
  }
}