import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:topon_ad_plugin/topon_ad_plugin.dart';

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

  void updateStatus(Future<String> Function() action) async {
    final String result = await action();
    setState(() => status = result);
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
                onPressed: () => updateStatus(destroyBanner),
                child: const Text('Destroy Banner'),
              ),
              ElevatedButton(
                onPressed: () => updateStatus(loadSplash),
                child: const Text('Load Splash'),
              ),
              ElevatedButton(
                onPressed: () => updateStatus(loadNative),
                child: const Text('Load Native'),
              ),
              ElevatedButton(
                onPressed: () => updateStatus(showNative),
                child: const Text('Show Native'),
              ),
              Text(status, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
