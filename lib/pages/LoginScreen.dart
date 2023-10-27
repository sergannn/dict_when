import 'dart:convert';
//import 'package:example/demo/demo.dart';
//import 'package:example/demo/settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'settings.dart';

void main() => runApp(const StartApp());

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Dictofon';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        //  appBar: AppBar(
        //    title: const Text(appTitle),
        //  ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  MyCustomForm({super.key});

  //get http => null;
  final url = 'soundblaster.onrender.com';

  final api_id_Controller = TextEditingController();
  final api_hash_Controller = TextEditingController();
  final api_phone_Controller = TextEditingController();
  final api_to_phone_Controller = TextEditingController();

  verify_code(arg, api, hash, phone, code, hash_code, context) async {
    print("verifing");
    final params = {
      'api_id': api,
      'api_hash': hash,
      'target_username': 'me',
      'code': code,
      'phone': phone,
      'phone_code_hash': hash_code
    };
    //var uri = Uri.https("soundblaster.onrender.com", "/verify_code", params);
    var uri = Uri.https("soundblaster.onrender.com", "/verify_code", params);
    var response = await http.post(uri);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var responseData = json.decode(response.body);
    var res = responseData['success'];
    print(res);
    if (res == "true") {
      await Fluttertoast.showToast(
          msg: "Вы авторизованы",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      //Navigator.of(context).push(
      //  MaterialPageRoute(
      //    builder: (context) => SettingsScreen(),
      //  ),
      //);
    }
  }

  send_to_python(arg, api, hash, phone, context) async {
    if (arg == "code") {
      print({api, hash, phone});
      final params = {
        'api_id': api,
        'api_hash': hash,
        'target_username': 'me',
        'phone': phone
      };
      if (api.toString().isEmpty ||
          hash.toString().isEmpty ||
          phone.toString().isEmpty) {
        await Fluttertoast.showToast(
            msg: "Не заполнены данные",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return http.Response('{ "error":"no values"}', 487);
      }
      var uri = Uri.https("soundblaster.onrender.com", "/start_auth", params);
      //var uri = Uri.https("soundblaster.onrender.com", "/start_auth", params);
      var response = await http.post(uri).timeout(Duration(seconds: 7),
          onTimeout: () async {
        print("no connection");

        await Fluttertoast.showToast(
            msg: "Нет подключения, попробуйте через минуту",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        //send_to_python(arg, api, hash, phone, context);
        return http.Response('{ "error":"408"}', 487);
        //http.Response('Error', 408);
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      var responseData = json.decode(response.body);
      var code_hash = responseData['code_hash'];
      if (responseData['success'] == 'true') {
        await Fluttertoast.showToast(
            msg: "Вы авторизованы",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (responseData["code"] == "enter code") {
        var written_code =
            await prompt(context, textOK: Text("ok"), hintText: "enter code");
        print(written_code);
        if (code_hash.isNotEmpty) {
          print("code_hash:" + code_hash);
          verify_code(
              "verify", api, hash, phone, written_code, code_hash, context);
        } else {
          print("code hash is empty");
          print("trying without");
          verify_code(
              "verify", api, hash, phone, written_code, code_hash, context);
        }
      }
    }
    //print(await http.read(Uri.parse(url)));
    /*var request = http.MultipartRequest('POST', Uri.parse(url));
    print(url);
    request.files.add(http.MultipartFile(
        'picture', File(path).readAsBytes().asStream(), File(path).lengthSync(),
        filename: 'ser.mp4'));
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    print(respStr);*/
  }

  get_shared() async {
    print("getting shared");
    final _prefs = await SharedPreferences.getInstance();
    api_hash_Controller.text = _prefs.getString('api_hash')!.isNotEmpty
        ? _prefs.getString('api_hash')!
        : "";
    api_id_Controller.text = _prefs.getString('api_id')!.isNotEmpty
        ? _prefs.getString('api_id')!
        : "";
    api_phone_Controller.text =
        _prefs.getString('phone')!.isNotEmpty ? _prefs.getString('phone')! : "";
    api_to_phone_Controller.text = _prefs.getString('to_phone')!.isNotEmpty
        ? _prefs.getString('to_phone')!
        : "";

    //return
  }

  save_api() async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('api_hash', api_hash_Controller.text);
    await _prefs.setString('api_id', api_id_Controller.text);
    await _prefs.setString('phone', api_phone_Controller.text);

    await _prefs.setString('to_phone', api_to_phone_Controller.text);
    print(_prefs.getString('api_hash'));
    print(_prefs.getString('api_id'));
    print(_prefs.getString('phone'));
  }

  @override
  Widget build(BuildContext context) {
    get_shared(); /*
    send_to_python("code", api_id_Controller.text, api_hash_Controller.text,
        api_phone_Controller.text, context);*/
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15),
        TextField(
          //obscureText: true,
          controller: api_id_Controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'api_id',
          ),
        ),
        SizedBox(height: 15),
        TextField(
          //obscureText: true,

          controller: api_hash_Controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'api_hash',
          ),
        ),
        SizedBox(height: 15),
        TextField(
          //obscureText: true,
          controller: api_phone_Controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'phone',
          ),
        ),
        SizedBox(height: 15),
        TextField(
          //obscureText: true,
          controller: api_to_phone_Controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'получатель',
          ),
        ),
        Center(
            child: Column(children: [
          ElevatedButton(
            child: Text("авторизация"),
            onPressed: () {
              send_to_python("code", api_id_Controller.text,
                  api_hash_Controller.text, api_phone_Controller.text, context);
              //send_to_python(audioFilePath);
            },
          ),
          ElevatedButton(
            child: Text("сохранить данные"),
            onPressed: () {
              save_api();
              // _prefs.setInt('counter', counter);
              //_prefs.setInt()
              //   api_id_Controller.text,
              //  api_hash_Controller.text,
              //  api_phone_Controller.text
              //send_to_python(audioFilePath);
            },
          ),
          ElevatedButton(
            child: Text("получить данные из памяти"),
            onPressed: () {
              get_shared();
              // _prefs.setInt('counter', counter);
              //_prefs.setInt()
              //   api_id_Controller.text,
              //  api_hash_Controller.text,
              //  api_phone_Controller.text
              //send_to_python(audioFilePath);
            },
          ),
          /*  ElevatedButton(
            child: Text("настройки"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ));
            },
          )*/
        ]))
      ],
    );
  }
}
