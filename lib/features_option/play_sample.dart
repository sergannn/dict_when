import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

void main() => runApp(
      MaterialApp(home: MySoundPlayerPage()),
    );

class MySoundPlayerPage extends StatelessWidget {
  FlutterSoundPlayer _soundPlayer = FlutterSoundPlayer();

  Future<void> playSoundFromUrl(String url) async {
    await _soundPlayer.openPlayer();
    await _soundPlayer.startPlayer(fromURI: Uri.parse(url).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sound Player'),
      ),
      body: Center(
        child: Column(children: [
          TextButton(
            child: Text('Play Sound', textDirection: TextDirection.ltr),
            onPressed: () {
              playSoundFromUrl(
                  'https://file-examples.com/storage/feaade38c1651bd01984236/2017/11/file_example_MP3_700KB.mp3'
                  //   'https://file-examples.com/storage/feaade38c1651bd01984236/2017/11/file_example_MP3_700KB.mp3');
                  );
            },
          )
        ]),
      ),
    );
  }
}
