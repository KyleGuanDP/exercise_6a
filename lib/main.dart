import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4 Function Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

//
// ------------------------ PART 1 ------------------------
//  GUI-Based Calculator (No TextField)
//
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _input = '';
  String _output = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _output = '';
      } else if (value == '=') {
        _calculate();
      } else {
        _input += value;
      }
    });
  }

  void _calculate() {
    try {
      final exp = _input.replaceAll('×', '*').replaceAll('÷', '/');
      final result = _evaluateExpression(exp);
      _output = result.toString();
    } catch (e) {
      _output = 'Error';
    }
  }

  double _evaluateExpression(String exp) {
    // Basic 4-function evaluation (no packages)
    List<String> tokens = exp.split(RegExp(r'([+\-*/])')).map((e) => e.trim()).toList();
    if (tokens.length < 3) return double.tryParse(tokens[0]) ?? 0;

    double num1 = double.parse(tokens[0]);
    String op = exp.contains('+')
        ? '+'
        : exp.contains('-')
            ? '-'
            : exp.contains('*')
                ? '*'
                : '/';
    double num2 = double.parse(tokens[2]);

    switch (op) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      case '/':
        return num2 != 0 ? num1 / num2 : double.nan;
      default:
        return 0;
    }
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button-based Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FormCalculatorScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(_input, style: const TextStyle(fontSize: 28)),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(_output, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          Expanded(
            child: Column(
              children: [
                Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('÷')]),
                Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('×')]),
                Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-')]),
                Row(children: [_buildButton('C'), _buildButton('0'), _buildButton('='), _buildButton('+')]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
// ------------------------ PART 2 ------------------------
//  TextFormField-based Calculator
//
class FormCalculatorScreen extends StatefulWidget {
  const FormCalculatorScreen({super.key});

  @override
  State<FormCalculatorScreen> createState() => _FormCalculatorScreenState();
}

class _FormCalculatorScreenState extends State<FormCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _num1Controller = TextEditingController();
  final _num2Controller = TextEditingController();
  String _result = '';

  void _calculate(String operation) {
    if (_formKey.currentState!.validate()) {
      double num1 = double.parse(_num1Controller.text);
      double num2 = double.parse(_num2Controller.text);
      double result;

      switch (operation) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '×':
          result = num1 * num2;
          break;
        case '÷':
          result = num2 != 0 ? num1 / num2 : double.nan;
          break;
        default:
          result = 0;
      }

      setState(() {
        _result = result.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FormField Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _num1Controller,
                decoration: const InputDecoration(labelText: 'Enter first number'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a number';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              TextFormField(
                controller: _num2Controller,
                decoration: const InputDecoration(labelText: 'Enter second number'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a number';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(onPressed: () => _calculate('+'), child: const Text('+')),
                  ElevatedButton(onPressed: () => _calculate('-'), child: const Text('-')),
                  ElevatedButton(onPressed: () => _calculate('×'), child: const Text('×')),
                  ElevatedButton(onPressed: () => _calculate('÷'), child: const Text('÷')),
                ],
              ),
              const SizedBox(height: 30),
              Text('Result: $_result', style: const TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
