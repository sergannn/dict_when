import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features_single/single_main.dart';
import 'features_multi/multi_main.dart';
import 'features_tile/tile_main.dart';
import 'features_option/option_main.dart';
import 'features_modal/modal_main.dart';
import 'features_choices/choices_main.dart';
import 'features_brightness.dart';
import 'features_color.dart';
import 'features_option/images.dart';
// import 'features_theme.dart';
import 'keep_alive.dart';
import 'pages/settings.dart';
import 'pages/dict.dart';
import 'pages/LoginScreen.dart';

class Features extends StatelessWidget {
  Future<void> _refreshTabData(int tabIndex) async {
    // Ваша логика обновления данных для вкладки с индексом tabIndex
    await Future.delayed(Duration(seconds: 2)); // Пример задержки
    //setState(() {
    //  // Обновление состояния вкладки
    //});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dict'),
          bottom: TabBar(
            onTap: (value) {
              print(value);

              /*    print(value);
              if (value == 5) {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => Demo(),
                ));
              }*/
            },
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Авторизация'),
              Tab(text: 'Настройки'),
              Tab(text: 'Диктофон'),
              Tab(text: 'Обои'),
              //    Tab(text: 'Customize Modal'),
              //    Tab(text: 'Customize Tile'),
            ],
          ),
          actions: <Widget>[
            FeaturesBrightness(),
            FeaturesColor(),
            CircleAvatar(child: Text("a")),
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () => _about(context),
            )
          ],
        ),
        body: TabBarView(
          children: [
            KeepAliveWidget(
              child: StartApp(),
            ),
            KeepAliveWidget(
              child: FeaturesOption(),
            ),
            RefreshIndicator(
              onRefresh: () => _refreshTabData(0),
              //child: //KeepAliveWidget(
              child: Demo(),
              //)
            ),
            KeepAliveWidget(
              child: ImageGridPage(),
            ),
          ],
        ),
        // bottomNavigationBar: Card(
        //   elevation: 3,
        //   margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        //   child: FeaturesTheme(),
        // ),
      ),
    );
  }

  void _about(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                'awesome_select',
                style: Theme.of(context).textTheme.headline5,
              ),
              subtitle: Text('by davigmacode'),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Smart select allows you to easily convert your usual form selects to dynamic pages with grouped radio or checkbox inputs. This widget is inspired by Smart Select component from Framework7',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Container(height: 15),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
