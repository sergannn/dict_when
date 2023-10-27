import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:http/http.dart' as http;
import 'package:serj/choices.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_sound/flutter_sound.dart';

//void main() => runApp(FeaturesOptionDisabled());

class FeaturesOptionDisabled extends StatefulWidget {
  @override
  _FeaturesOptionDisabledState createState() => _FeaturesOptionDisabledState();
}

class _FeaturesOptionDisabledState extends State<FeaturesOptionDisabled> {
  List<int> _categories = [];
  bool sounds_mode = false;
  bool record_mode = false;
  int? _sort = 0;
  List<String> sounds = [];
//  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  List<String> _categoriesOption = [
    'Electronics',
    'Accessories',
    'Smartwatch',
    'Smartphone',
    'Audio & Video',
    'Scientific'
  ];
  String start_sound_name = "";
  int start_sound_index = 0;
  String stop_sound_name = "";
  int stop_sound_index = 0;
  bool _player_opened = false;
  List<String> _sortOption = [
    'Popular',
    'Most Reviews',
    'Newest',
    'Low Price',
    'High Price',
  ];

  void initState() {
    super.initState();
    fetchData();
    // playerModule.openPlayer().then((value) {
    //   setState(() {
    //    _player_opened = true;
    //  });
    // });
  }

  @override
  void dispose() {
    // Be careful : you must `close` the audio session when you have finished with it.
    //  playerModule.closePlayer();
    //playerModule = null;
    super.dispose();
  }

  Future<void> fetchData() async {
    print("finding mode");
    get_sounds_mode();
    get_record_mode();
    print("trying to find sounds");
    get_start_sound();
    get_stop_sound();

    final response = await http.get(Uri.parse(
        'http://3.u0156265.z8.ru/itmo2020/Student/sounds/SHAKE/index.php')); // Замените URL на ваш реальный URL для получения JSON-массива

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        sounds = List<String>.from(
            jsonData); // Предполагается, что JSON-массив содержит строки
        //  print(sounds);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  set_record_mode(off) async {
    print("switching record mode");
    print(off);
    record_mode = off;
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('record_mode', off);
  }

  get_record_mode() async {
    print("switching record mode");
    final _prefs = await SharedPreferences.getInstance();
    //_prefs.setBool('record_mode', off);
    if (_prefs.getKeys().contains("record_mode")) {
      print("нашел");
      record_mode = _prefs.getBool('record_mode')!;
    }
  }

  set_sounds_mode(off) async {
    print("switching");
    print(off);
    sounds_mode = off;
    print(sounds_mode);
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('sounds_mode', off);
  }

  get_sounds_mode() async {
    print("getting mode");
    final _prefs = await SharedPreferences.getInstance();
    print(_prefs.getKeys());
    if (_prefs.getKeys().contains("sounds_mode")) {
      print("нашел");
      sounds_mode = _prefs.getBool('sounds_mode')!;
    }
  }

  play_sound(exit, index) async {
    //ind = int.parse(index)
    //print(sounds[int.parse(index)]);
    print(exit);
    print(index);
    final _prefs = await SharedPreferences.getInstance();
    if (exit == false) {
      await _prefs.setInt('start_sound_index', index);
      await _prefs.setString('start_sound_name', sounds[index]);
    } else {
      await _prefs.setInt('stop_sound_index', index);
      await _prefs.setString('stop_sound_name', sounds[index]);
    }
    print("saved....");
    //await _prefs.setString('api_id', api_id_Controller.text);
    //await _prefs.setString('phone', api_phone_Controller.text);
    final player = AudioPlayer(); // Create a player
    var link2 = 'https://sound-samples.onrender.com/' + sounds[index];
    var final_link = Uri.parse(link2).toString();
    //print(final_link);
    // var test_link =
    //     'https://sound-samples.onrender.com/Hi%20Seed%20Shaker%201.mp3';
    // var link =
    //     'https://file-examples.com/storage/feaade38c1651bd01984236/2017/11/file_example_MP3_700KB.mp3';
    print(link2);
    final duration = await player.setUrl(final_link); // Load a URL
    //    'http://3.u0156265.z8.ru/itmo2020/Student/sounds/SHAKE/samples/' +
    //        sounds[int.parse(url)]); // Schemes: (https: | file: | asset: )
//player.play();                                  // Play without waiting for completion
    await player.play(); // Play while waiting for completion
//    await player.pause(); // Pause but remain ready to play
//    await player.seek(Duration(seconds: 10)); // Jump to the 10 second position
//    await player.setSpeed(2.0); // Twice as fast
//    await player.setVolume(0.5); // Half as loud
//    await player.stop();
    //   final fileUri = Uri.parse(
    //       "http://3.u0156265.z8.ru/itmo2020/Student/sounds/SHAKE/samples/" +
    //           sounds[int.parse(url)]);
//    print('file is: ' + fileUri.toString());
    // var  d2 = await playerModule.startPlayer(
    //     fromUri: fileUri
    //   );
    //var d = await playerModule.startPlayer(
    //   fromURI: fileUri.toString(),
    //   codec: Codec.defaultCodec,
    //   whenFinished: () {
    //     print('finished');
    // logger.d( 'I hope you enjoyed listening to this song' );
    // },
    // );
  }

  get_stop_sound() async {
    final _prefs = await SharedPreferences.getInstance();

    stop_sound_name = _prefs.getString("stop_sound_name")!.isNotEmpty
        ? _prefs.getString("stop_sound_name")!
        : "";

    stop_sound_index = (_prefs.getInt("stop_sound_index")!.isNaN
        ? 0
        : _prefs.getInt("stop_sound_index"))!;
    print(stop_sound_name);
    print(stop_sound_index);
    //return await _prefs.getInt('start_sound')!.isNaN
    //    ? 0
    //    : await _prefs.getInt('start_sound');
  }

  get_start_sound() async {
    final _prefs = await SharedPreferences.getInstance();

    start_sound_name = _prefs.getString("start_sound_name")!.isNotEmpty
        ? _prefs.getString("start_sound_name")!
        : "";

    start_sound_index = (_prefs.getInt("start_sound_index")!.isNaN
        ? 0
        : _prefs.getInt("start_sound_index"))!;
    print(start_sound_name);
    print(">>index");
    print(start_sound_index);
    //return await _prefs.getInt('start_sound')!.isNaN
    //    ? 0
    //    : await _prefs.getInt('start_sound');
  }

  @override
  Widget build(BuildContext context) {
    print('sounds...');
    // print(sounds);
    print(start_sound_index);
    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        Card(
          elevation: 3,
          margin: const EdgeInsets.all(10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: SmartSelect<int>.single(
                  title: 'Звук при старте', //+ start_sound_index.toString(),
                  selectedValue: start_sound_index,
                  onChange: (selected) {
                    play_sound(false, selected.value);
                    //setState(() => _categories = selected.value);
                  },
                  //options: sounds,
                  choiceItems: S2Choice.listFrom<int, String>(
                    source: sounds, //_categoriesOption,
                    value: (index, item) => index,
                    title: (index, item) => item,
                    //  disabled: (index, item) => [0, 2, 5].contains(index),
                  ),
                  choiceType: S2ChoiceType.switches,
                  modalType: S2ModalType.popupDialog,
                  modalHeader: false,
                  tileBuilder: (context, state) {
                    return S2Tile.fromState(
                      state,
                      trailing: const Icon(Icons.arrow_drop_down),
                      isTwoLine: true,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 40,
                child: VerticalDivider(),
              ),
              Expanded(
                child: SmartSelect<int?>.single(
                  selectedValue: stop_sound_index,
                  onChange: (selected) {
                    play_sound(true, selected.value);
                    //setState(() => _sort = selected.value);
                  },
                  choiceItems: S2Choice.listFrom<int, String>(
                    source: sounds,
                    value: (index, item) => index,
                    title: (index, item) => item,
                    //  disabled: (index, item) =>
                    //      item.toLowerCase().contains('price'),
                  ),
                  modalType: S2ModalType.popupDialog,
                  modalHeader: false,
                  modalTitle: 'Звук при выходе',
                  tileBuilder: (context, state) {
                    return S2Tile.fromState(
                      state,
                      trailing: const Icon(Icons.arrow_drop_down),
                      isTwoLine: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Card(
            elevation: 3,
            margin: const EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Включить дополнительные звуки"),
                    Switch(
                      value: sounds_mode,
                      onChanged: (value) {
                        setState(() {
                          print(value);
                          set_sounds_mode(value);
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    )
                  ]),
            )),
        Card(
            elevation: 3,
            margin: const EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Запись нажатием"),
                    Switch(
                      value: record_mode, //isSwitched,
                      onChanged: (value) {
                        setState(() {
                          print(value);
                          set_record_mode(value);
                        });
                        // setState(() {
                        //isSwitched=value;
                        //print(isSwitched);
                        // });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    )
                  ]),
            )),
        /*   Card(
            elevation: 3,
            margin: const EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Выбрать обои"),
                  ]),
            )),*/
      ],
    );
  }
}
