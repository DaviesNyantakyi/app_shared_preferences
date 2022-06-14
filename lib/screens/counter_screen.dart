import 'package:local_app_shared_preferences/providers/theme_notifier.dart';
import 'package:local_app_shared_preferences/screens/theme_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;
  @override
  void initState() {
    getCounter();
    super.initState();
  }

  Future<void> setCounter({required int number}) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt('counter', number);
  }

  Future<void> getCounter() async {
    final pref = await SharedPreferences.getInstance();
    counter = pref.getInt('counter') ?? 0;

    setState(() {});
  }

  Future<void> increment() async {
    counter++;
    await setCounter(number: counter);
    setState(() {});
  }

  Future<void> decrement() async {
    counter--;
    await setCounter(number: counter);
    setState(() {});
  }

  Future<void> resetCounter() async {
    counter = 0;
    final pref = await SharedPreferences.getInstance();
    await pref.remove('counter');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sunny),
            onPressed: () async {
              final themeNotifer =
                  Provider.of<ThemeNotifer>(context, listen: false);
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: themeNotifer,
                    child: const ThemeScreen(),
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$counter',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'decrement',
                  onPressed: decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 24),
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: resetCounter,
              child: const Text('Reset counter'),
            ),
          ],
        ),
      ),
    );
  }
}
