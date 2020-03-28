import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImpressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('impress', context: context)),
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
                title: Text(tr('app_info', context: context),
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
                title: Text(tr('third_party_packages', context: context),
                    style: Theme.of(context).textTheme.subtitle1)),
            ListTile(
                title: Text('permission_handler',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_permission_handler', context: context)),
                onTap: () {
                  launch('https://pub.dev/packages/permission_handler');
                }),
            ListTile(
                title: Text('folder_picker',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_folder_picker', context: context)),
                onTap: () {
                  launch('https://pub.dev/packages/folder_picker');
                }),
            ListTile(
                title: Text('flutter_ffmpeg',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_flutter_ffmpeg', context: context)),
                onTap: () {
                  launch('https://pub.dev/packages/flutter_ffmpeg');
                }),
            ListTile(
                title: Text('archive',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_archive', context: context)),
                onTap: () {
                  launch('https://pub.dev/packages/archive');
                }),
            ListTile(
                title: Text('flutter_isolate',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_flutter_isolate', context: context)),
                onTap: () {
                  launch('https://pub.dev/packages/flutter_isolate');
                }),
            ListTile(
                title: Text('audioplayers',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_audioplayers', context: context)),
                onTap: () {
                  launch('https://pub.dev/packages/audioplayers');
                }),
            ListTile(
                title: Text('fluttertoast',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_fluttertoast', context: context)),
                onTap: () {
                  launch('https://pub.dev/packages/fluttertoast');
                }),
            ListTile(
                title: Text('moor, moor_ffi',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_moor', context: context)),
                onTap: () {
                  launch('https://pub.dev/packages/moor');
                }),
            ListTile(
              title: Text('provider',
                  style: Theme.of(context).textTheme.bodyText2),
              subtitle: Text(tr('info_provider', context: context)),
              onTap: () {
                launch('https://pub.dev/packages/provider');
              },
            ),
            ListTile(
                title: Text('url_launcher',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_url_launcher', context: context)),
                onTap: () {
                  launch('https://pub.dev/packages/url_launcher');
                }),
            ListTile(
                title: Text('shared_preferences_settings',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_shared_preferences_settings', context: context)),
                onTap: () {
                  launch(
                      'https://pub.dev/packages/shared_preferences_settings');
                }),
            ListTile(
                title: Text('easy_localization',
                    style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(tr('info_easy_localization', context: context)),
                onTap: () {
                  launch('https://pub.dev/packages/easy_localization');
                })
          ],
        ).toList(),
      ),
    );
  }
}
