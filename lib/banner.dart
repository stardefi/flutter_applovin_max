import 'package:flutter/foundation.dart';
import 'package:flutter_applovin_max/flutter_applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

enum BannerAdSize {
  banner,
  mrec,
  leader,
}

class BannerPx {
  final double width;
  final double height;
  BannerPx(this.width, this.height);
}

class BannerMaxView extends StatelessWidget {
  final AppLovinListener listener;
  final Map<BannerAdSize, String> sizes = {
    BannerAdSize.banner: 'BANNER',
    BannerAdSize.leader: 'LEADER',
    BannerAdSize.mrec: 'MREC'
  };
  final Map<BannerAdSize, BannerPx> sizesNum = {
    BannerAdSize.banner: BannerPx(350, 50),
    BannerAdSize.leader: BannerPx(double.infinity, 90),
    BannerAdSize.mrec: BannerPx(300, 250)
  };
  final BannerAdSize size;
  final String adUnitId;

  BannerMaxView(this.listener, this.size, this.adUnitId, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        color: Colors.transparent,
        width: sizesNum[size]?.width,
        height: sizesNum[size]?.height,
        child: AndroidView(
            viewType: '/Banner',
            key: UniqueKey(),
            creationParams: {'Size': sizes[size], 'UnitId': adUnitId},
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (int i) {
              const MethodChannel channel =
                  MethodChannel('flutter_applovin_max_banner');
              channel.setMethodCallHandler((MethodCall call) async =>
                  FlutterApplovinMax.handleMethod(call, listener));
            }),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        color: Colors.transparent,
        width: sizesNum[size]?.width,
        height: sizesNum[size]?.height,
        child: Center(
          child: UiKitView(
              viewType: '/Banner',
              creationParams: {'Size': sizes[size], 'UnitId': adUnitId},
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: (int i) {
                const MethodChannel channel =
                    MethodChannel('flutter_applovin_max_banner');
                channel.setMethodCallHandler((MethodCall call) async =>
                    FlutterApplovinMax.handleMethod(call, listener));
              }),
        ),
      );
    } else {
      return Container(
        height: sizesNum[size]?.width,
        child: const Center(
          child:
              Text('Banner Ads for this platform is currently not supported'),
        ),
      );
    }
  }
}
