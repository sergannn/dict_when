import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  //await initializeSettings(settingsCategories);
  runApp(MaterialApp(home: ImageGridPage()));
}

class ImageGridPage extends StatefulWidget {
  @override
  _ImageGridPageState createState() => _ImageGridPageState();
}

class _ImageGridPageState extends State<ImageGridPage> {
  List<String> imageUrls = [];
  var sub_url =
      'http://3.u0156265.z8.ru/itmo2020/Student/flutter_images/images/';
  String selectedImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    loadSelectedImageUrl();
  }

  Future<void> fetchData() async {
    print("finding images");

    final response = await http.get(Uri.parse(
        'http://3.u0156265.z8.ru/itmo2020/Student/flutter_images/index.php')); // Замените URL на ваш реальный URL для получения JSON-массива

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        imageUrls = List<String>.from(
            jsonData); // Предполагается, что JSON-массив содержит строки
        //  print(sounds);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> loadSelectedImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imageUrl = prefs.getString('selectedImageUrl') ?? '';
    setState(() {
      selectedImageUrl = imageUrl;
    });
  }

  Future<void> saveSelectedImageUrl(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedImageUrl', imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите изображение'),
      ),
      body: GridView.builder(
        itemCount: imageUrls.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Количество столбцов в сетке
        ),
        itemBuilder: (BuildContext context, int index) {
          String imageUrl = sub_url + imageUrls[index];
          bool isSelected = imageUrl == selectedImageUrl;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedImageUrl = imageUrl;
              });
              saveSelectedImageUrl(imageUrl);
            },
            child: Card(
              color: isSelected ? Colors.blue : null,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
