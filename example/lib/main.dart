import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:topon_ad_plugin/topon_ad_plugin.dart';
import 'package:topon_ad_plugin_example/native_ad_widget.dart';

import 'helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ToponAdHelper {
  String status = '';
  ToponNativeAdInfo? adInfo;

  void updateStatus(Future<String> Function() action) async {
    final String result = await action();
    setState(() => status = result);
  }

  void updateAdInfo(Future<ToponNativeAdInfo?> Function() action) async {
    final ToponNativeAdInfo? result = await action();
    if (result != null) {
      setState(() => adInfo = result);
      setState(() => status = 'Native Ad Info Loaded');
    } else {
      setState(() => status = 'Failed to Load Native Ad Info');
    }
  }

  @override
  void initState() {
    ToponAdPlugin.setUpListeners();
    ToponAdPlugin.onEvent = (method, args) {
      log('TopOn Event: $method | Args: $args');
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Topon Ads Example')),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => updateStatus(initializeTopon),
                  child: const Text('Initialize SDK'),
                ),
                ElevatedButton(
                  onPressed: () => updateStatus(loadInterstitial),
                  child: const Text('Load Interstitial'),
                ),
                ElevatedButton(
                  onPressed: () => updateStatus(showInterstitial),
                  child: const Text('Show Interstitial'),
                ),
                ElevatedButton(
                  onPressed: () => updateStatus(loadRewarded),
                  child: const Text('Load Rewarded'),
                ),
                ElevatedButton(
                  onPressed: () => updateStatus(showRewarded),
                  child: const Text('Show Rewarded'),
                ),
                ElevatedButton(
                  onPressed: () => updateStatus(loadBanner),
                  child: const Text('Load Banner'),
                ),
                ElevatedButton(
                  onPressed: () => updateStatus(removeBanner),
                  child: const Text('Remove Banner'),
                ),
                ElevatedButton(
                  onPressed: () => updateStatus(loadSplash),
                  child: const Text('Load Splash'),
                ),
                ElevatedButton(
                  onPressed: () => updateStatus(loadNative),
                  child: const Text('Load Native Ad'),
                ),
                ElevatedButton(
                  onPressed: () => updateAdInfo(getNativeAdInfo),
                  child: const Text('Get Native Ad Info'),
                ),
                Text(status, style: const TextStyle(fontSize: 16)),
                if (adInfo != null) NativeAdWidget(adInfo: adInfo!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
