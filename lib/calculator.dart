import 'package:calculator/model/calculation.dart';
import 'package:calculator/sqlite/database%20helper.dart';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String equation = '0';
  String result = '0';
  String expression = '';


  TextEditingController _equationController = TextEditingController();
  TextEditingController _resultController = TextEditingController();

  // In the CalculatorPage class
  void buttonPressed(String btnText) {
    setState(() {
      if (btnText == 'AC') {
        equation = '0';
        result = '0';
      } else if (btnText == '⌫') {
        if (equation.length > 1) {
          equation = equation.substring(0, equation.length - 1);
        } else {
          equation = '0';
        }
      } else if (btnText == '=') {
        expression = equation;
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression.replaceAll('×', '*').replaceAll('÷', '/'));
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          // Save calculation to database
          addCalculation();
        } catch (e) {
          result = 'Error';

        }
      } else {
        if (equation == '0') {
          equation = btnText;
        } else {
          equation += btnText;
        }
      }
    });
  }


  Future<void> addCalculation() async {
    await DatabaseHelper().insertCalculation(
      CalculationHistory(
        equation: equation,
        result: result,

      ),
    );
  }

  Widget calButtons(dynamic content, Color txtColor, double btnWidth, Color btnColor) {
    return InkWell(
      onTap: () {
        if (content is String) {
          buttonPressed(content);
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 60,
        width: btnWidth,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: content is String
            ? Text(content, style: TextStyle(fontSize: 35, color: txtColor))
            : Icon(content, color: txtColor, size: 35),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(200, 100)),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text('Calculator', style: TextStyle(fontSize: 30, color: Colors.white)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerRight,
            height: 80,
            width: double.infinity,
            color: Colors.black,
            child: SingleChildScrollView(
              child: Text(
                equation,
                style: TextStyle(fontSize: 35, color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerRight,
            height: 90,
            width: double.infinity,
            color: Colors.black,
            child: SingleChildScrollView(
              child: Text(
                result,
                style: TextStyle(fontSize: 60, color: Colors.white38, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    calButtons('AC', Colors.white, 80, Colors.deepOrangeAccent),
                    calButtons('⌫', Colors.white, 80, Colors.white38),
                    calButtons('%', Colors.white, 80, Colors.white38),
                    calButtons('÷', Colors.white, 80, Colors.deepOrangeAccent),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    calButtons('7', Colors.white, 80, Colors.white10),
                    calButtons('8', Colors.white, 80, Colors.white10),
                    calButtons('9', Colors.white, 80, Colors.white10),
                    calButtons('*', Colors.white, 80, Colors.deepOrangeAccent),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    calButtons('4', Colors.white, 80, Colors.white10),
                    calButtons('5', Colors.white, 80, Colors.white10),
                    calButtons('6', Colors.white, 80, Colors.white10),
                    calButtons('-', Colors.white, 80, Colors.deepOrangeAccent),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    calButtons('1', Colors.white, 80, Colors.white10),
                    calButtons('2', Colors.white, 80, Colors.white10),
                    calButtons('3', Colors.white, 80, Colors.white10),
                    calButtons('+', Colors.white, 80, Colors.deepOrangeAccent),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    calButtons('0', Colors.white, 150, Colors.white10),
                    calButtons('.', Colors.white, 80, Colors.white10),
                    calButtons('=', Colors.white, 80, Colors.deepOrangeAccent),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
