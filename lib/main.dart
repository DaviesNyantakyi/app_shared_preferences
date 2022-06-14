import 'package:local_app_shared_preferences/providers/theme_notifier.dart';
import 'package:local_app_shared_preferences/screens/counter_screen.dart';
import 'package:local_app_shared_preferences/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  final isDarkMode = pref.getBool('isDarkMode') ?? false;
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = isDarkMode ? Colors.yellow : Colors.black
    ..indicatorColor = isDarkMode ? Colors.yellow : Colors.black
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeNotifer(isDarkMode: isDarkMode),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifer>(
      builder: (context, themeNotifer, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifer.selectedTheme,
          home: const BottomNavScreen(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int selectedIndex = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            tooltip: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            tooltip: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
        onTap: (value) {
          selectedIndex = value;
          setState(() {});
        },
      ),
    );
  }
}
