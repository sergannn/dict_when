import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:settings_ui/settings_ui.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:awesome_select/awesome_select.dart';
//import 'package:dropdown_button2/dropdown_button2.dart';

void main() async {
  //await initializeSettings(settingsCategories);
  runApp(const SettingsScreen());
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen() : super();

  @override
  _IosDeveloperScreen createState() => _IosDeveloperScreen();
}

class _IosDeveloperScreen extends State<SettingsScreen> {
  bool darkTheme = true;
  List<String> items = ["a", "b"];
  String? selectedValue;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    print("trying");
    final response = await http.get(Uri.parse(
        'http://3.u0156265.z8.ru/itmo2020/Student/sounds/SHAKE/index.php')); // Замените URL на ваш реальный URL для получения JSON-массива

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        items = List<String>.from(
            jsonData); // Предполагается, что JSON-массив содержит строки
        print(items);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Настройки')),
        child: SafeArea(child: Text("hello")));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
