import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_applovin_max/flutter_applovin_max.dart';
import 'package:flutter_applovin_max/banner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    print('init state');
    FlutterApplovinMax.initSDK('', '', '');
    super.initState();
  }

  void listener(AppLovinAdListener event) {
    print(event);
    if (event == AppLovinAdListener.onUserRewarded) {
      print('👍get reward');
    }
  }

  bool isRewardedVideoAvailable = false;
  bool isInterstitialVideoAvailable = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            const Spacer(),
            TextButton(
              onPressed: () async {
                isRewardedVideoAvailable =
                    await FlutterApplovinMax.isRewardLoaded(listener);
                if (isRewardedVideoAvailable) {
                  FlutterApplovinMax.showRewardVideo(
                      (AppLovinAdListener event) => listener(event),
                      placementId: '',
                      custom: '');
                }
              },
              child: const Text('Show Reward Video'),
            ),
            TextButton(
              onPressed: () async {
                isInterstitialVideoAvailable =
                    await FlutterApplovinMax.isInterstitialLoaded(listener);
                if (isInterstitialVideoAvailable) {
                  FlutterApplovinMax.showInterstitialVideo(
                      (AppLovinAdListener event) => listener(event));
                }
              },
              child: const Text('Show Interstitial Video'),
            ),
            TextButton(
              onPressed: () async {
                await FlutterApplovinMax.showDebugger();
              },
              child: const Text('Show Debugger'),
            ),
            const Spacer(),
          ],
        )),
        // bottomNavigationBar: BannerMaxView(
        //     (AppLovinAdListener event) => print(event),
        //     BannerAdSize.banner,
        //     ''),
      ),
    );
  }
}
