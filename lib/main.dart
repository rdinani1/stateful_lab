import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Lab',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  final TextEditingController _controller = TextEditingController();
  final List<int> _history = [];

  void _saveHistory() {
    _history.add(_counter);
  }

  void _increment() {
    setState(() {
      if (_counter < 100) {
        _saveHistory();
        _counter++;
      }
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) {
        _saveHistory();
        _counter--;
      }
    });
  }

  void _reset() {
    setState(() {
      _saveHistory();
      _counter = 0;
    });
  }

  void _undo() {
    if (_history.isEmpty) return;
    setState(() {
      _counter = _history.removeLast();
    });
  }

  Color _counterColor() {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.black;
  }

  void _setValueFromInput() {
    final text = _controller.text.trim();
    final parsed = int.tryParse(text);

    if (parsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid number.")),
      );
      return;
    }

    if (parsed > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Limit Reached!")),
      );
      return;
    }

    if (parsed < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Value cannot be below 0.")),
      );
      return;
    }

    setState(() {
      _saveHistory();
      _counter = parsed;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canUndo = _history.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Counter'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.blue.shade100,
              padding: const EdgeInsets.all(20),
              child: Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 50.0,
                  color: _counterColor(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _saveHistory();
                _counter = value.toInt();
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _decrement,
                child: const Text("-"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _increment,
                child: const Text("+"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _reset,
                child: const Text("Reset"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: canUndo ? _undo : null,
                child: const Text("Undo"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter a number (0–100)",
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _setValueFromInput,
            child: const Text("Set Value"),
          ),
        ],
      ),
    );
  }
}
