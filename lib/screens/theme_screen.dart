import 'package:local_app_shared_preferences/providers/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Consumer<ThemeNotifer>(
                builder: (context, themeNotifer, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        themeNotifer.selectedTheme?.brightness ==
                                Brightness.dark
                            ? 'Dark mode'
                            : 'Light mode',
                      ),
                      Switch(
                        value: themeNotifer.selectedTheme?.brightness ==
                                Brightness.dark
                            ? true
                            : false,
                        onChanged: (value) async {
                          await themeNotifer.setTheme();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
