import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImpressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Impressum"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        children: ListTile.divideTiles(
          color: Colors.grey,
          context: context,
          tiles: <Widget>[
            ListTile(
                contentPadding:
                    EdgeInsetsDirectional.only(start: 16, end: 16, bottom: 20),
                title: Text(
                    'Diese App wurde für das Fach "Android Entwicklung" der FH Fulda programmiert von:',
                    style: Theme.of(context).textTheme.subtitle1)),
            ListTile(
              title: Text('Kilian Eller',
                  style: Theme.of(context).textTheme.headline5),
              trailing: new Image.asset(
                'asset/images/linkedin.png',
                height: 28,
              ),
              onTap: () {
                launch('https://www.linkedin.com/in/kilian-eller-aa512b167/');
              },
            ),
            ListTile(
                title: Text('Oliver',
                    style: Theme.of(context).textTheme.headline5)),
            ListTile(
                contentPadding:
                    EdgeInsetsDirectional.only(start: 16, end: 16, top: 25),
                title: Text('Third Party Flutter Packages:',
                    style: Theme.of(context).textTheme.subtitle1)),
            ListTile(
                title: Text('permission_handler',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text('Berechtigung zum Zugriff auf Datein'),
                onTap: () {
                  launch('https://pub.dev/packages/permission_handler');
                }),
            ListTile(
                title: Text('folder_picker',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text('Auswahl des Musikordners'),
                onTap: () {
                  launch('https://pub.dev/packages/folder_picker');
                }),
            ListTile(
                title: Text('flutter_ffmpeg',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text('Einlesen der Song Informationen'),
                onTap: () {
                  launch('https://pub.dev/packages/flutter_ffmpeg');
                }),
            ListTile(
                title: Text('archive',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text('Hashwert für die Albumcover'),
                onTap: () {
                  launch('https://pub.dev/packages/archive');
                }),
            ListTile(
                title: Text('flutter_isolate',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(
                    'Hintergrundthread für eine flüssige Ui beim Einlesen'),
                onTap: () {
                  launch('https://pub.dev/packages/flutter_isolate');
                }),
            ListTile(
                title: Text('audioplayers',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text('Abspielen der Musik'),
                onTap: () {
                  launch('https://pub.dev/packages/audioplayers');
                }),
            ListTile(
                title: Text('fluttertoast',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(
                    'Popup wenn ein Lied zur Warteschlange hinzugefügt wurde'),
                onTap: () {
                  launch('https://pub.dev/packages/fluttertoast');
                }),
            ListTile(
                title: Text('moor, moor_ffi',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle:
                    Text('Speichern der Daten in einer sqflite Datenbank'),
                onTap: () {
                  launch('https://pub.dev/packages/moor');
                }),
            ListTile(
              title: Text('provider',
                  style: Theme.of(context).textTheme.bodyText2),
              subtitle:
                  Text('Zugriff auf Datenbankabfragen aus den Widgets heraus'),
              onTap: () {
                launch('https://pub.dev/packages/provider');
              },
            ),
            ListTile(
                title: Text('url_launcher',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text('Öffnen der Links auf dieser Seite'),
                onTap: () {
                  launch('https://pub.dev/packages/url_launcher');
                }),
            ListTile(
                title: Text('shared_preferences_settings',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text('Anzeige der Einstellungen'),
                onTap: () {
                  launch(
                      'https://pub.dev/packages/shared_preferences_settings');
                }),
            ListTile(
                title: Text('easy_localization',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text('Mehrsprachiger Text'),
                onTap: () {
                  launch('https://pub.dev/packages/easy_localization');
                }),
          ],
        ).toList(),
      ),
    );
  }
}
