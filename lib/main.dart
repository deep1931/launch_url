// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Launcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _launched;
  String _phone = '';

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewWithDomStorage(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableDomStorage: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchUniversalLinkIos(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  Future<void> _sendEmail() async {
    String msgPacket =
        'mailto:info@flutterfumes.com?subject=Email Launcher Example&body=Hello, www.flutterfumes.com';
    if (await canLaunch(msgPacket)) {
      await launch(msgPacket);
    } else {
      throw 'Could not launch $msgPacket';
    }
  }

  Future<void> _sendMessage() async {
    String url;

    if (Platform.isAndroid) {
      //FOR Android
      url = 'sms:+6000000000?body=this is message';
      await launch(url);
    } else if (Platform.isIOS) {
      //FOR IOS
      url = 'sms:+6000000000&body=this is message';
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    const String toLaunch = 'https://www.flutterfumes.com';
    return Scaffold(
      appBar: AppBar(
        title: Text('Url Launcher'),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                    onChanged: (String text) => _phone = text,
                    decoration: const InputDecoration(
                        hintText: 'Input the phone number to launch')),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(toLaunch),
              ),
              ListTile(
                onTap: () {
                  _launched = _makePhoneCall('tel:$_phone');
                },
                title: Text('Make phone call'),
              ),
              ListTile(
                onTap: () {
                  _launched = _sendEmail();
                },
                title: Text('Send Email'),
              ),
              ListTile(
                onTap: () {
                  _launched = _sendMessage();
                },
                title: Text('Send SMS'),
              ),
              ListTile(
                onTap: () {
                  _launched = _launchInWebViewOrVC(toLaunch);
                },
                title: Text('Launch in browser'),
              ),
              ListTile(
                onTap: () {
                  _launched = _launchInBrowser(toLaunch);
                },
                title: Text('Launch in app'),
              ),
              ListTile(
                onTap: () {
                  _launched = _launchInWebViewWithJavaScript(toLaunch);
                },
                title: Text('Launch in app(JavaScript ON)'),
              ),
              ListTile(
                onTap: () {
                  _launched = _launchInWebViewWithDomStorage(toLaunch);
                },
                title: Text('Launch in app(DOM storage ON)'),
              ),
              ListTile(
                onTap: () {
                  _launched = _launchUniversalLinkIos(toLaunch);
                },
                title: Text(
                    'Launch a universal link in a native app, fallback to Safari.(Youtube)'),
              ),
              ListTile(
                onTap: () {
                  _launched = _launchInWebViewOrVC(toLaunch);
                  Timer(const Duration(seconds: 5), () {
                    print('Closing WebView after 5 seconds...');
                    closeWebView();
                  });
                },
                title: Text('Launch in app + close after 5 seconds'),
              ),
              const Padding(padding: EdgeInsets.all(16.0)),
              FutureBuilder<void>(future: _launched, builder: _launchStatus),
            ],
          ),
        ],
      ),
    );
  }
}
