import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = MethodChannel('samples.flutter.dev/channel');

  String _message = "";
  final TextEditingController _controller = TextEditingController();

  _MyHomePageState() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'sendToFlutter') {
        setState(() {
          _message = "iOS Native: " + call.arguments;
        });
      }
    });
  }

  Future<void> _backToNative() async {
    String text = _controller.text;
    try {
      final result = await platform.invokeMethod<int>('backToNative', text);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _message,
              style: const TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 16
            ),
            Container(
              constraints: const BoxConstraints(
                maxHeight: 48
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter message.',
                )
              )
            ),
            SizedBox(
              height: 16
            ),
            ElevatedButton(
              onPressed: _backToNative,
              child: const Text('Send and back iOS'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),  
              )
            )
          ],
        ),
      ),
    );
  }
}
