import 'package:material_ui/material_ui.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates the root widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Lab',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const CounterPage(),
    );
  }
}

/// Screen with a counter and a text input that controls it.
class CounterPage extends StatefulWidget {
  /// Creates the counter screen.
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  /// The exact command that resets the counter to zero.
  static const String _resetCommand = 'Avada Kedavra';

  /// Reads the text typed by the user.
  final TextEditingController _controller = TextEditingController();

  /// Current value of the counter.
  int _counter = 0;

  /// Error text under the input field. `null` means "no error".
  String? _errorText;

  @override
  void dispose() {
    // Free the resources held by the controller.
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final String input = _controller.text.trim();
    final int? number = int.tryParse(input);

    if (input == _resetCommand) {
      // Scenario 2: reset command.
      setState(() {
        _counter = 0;
        _errorText = null;
      });
      _controller.clear();
    } else if (number != null) {
      // Scenario 1: valid integer, add it to the counter.
      setState(() {
        _counter += number;
        _errorText = null;
      });
      _controller.clear();
    } else {
      // Scenario 3: invalid input, the counter stays unchanged.
      setState(() {
        _errorText = 'Введіть ціле число або "$_resetCommand"';
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Невалідне значення. Лічильник не змінено.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лічильник')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Поточне значення:'),
              const SizedBox(height: 8),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Введіть число або команду',
                  border: const OutlineInputBorder(),
                  errorText: _errorText,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Підтвердити'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
