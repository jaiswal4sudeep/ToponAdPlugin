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
  final TextEditingController _userIdController = TextEditingController(
    text: 'demo-user-123',
  );
  late final TextEditingController _rewardTransactionController;

  String _newRewardTransactionId() =>
      'reward-${DateTime.now().microsecondsSinceEpoch}';

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
    super.initState();
    _rewardTransactionController = TextEditingController(
      text: _newRewardTransactionId(),
    );
    ToponAdPlugin.setUpListeners();
    ToponAdPlugin.onEvent = (method, args) {
      log('TopOn Event: $method | Args: $args');
      if (method == 'onReward' && mounted) {
        setState(() {
          status =
              'Client reward event received. Credit only after your '
              'backend verifies the S2S callback.';
        });
      }
    };
  }

  @override
  void dispose() {
    ToponAdPlugin.onEvent = null;
    _userIdController.dispose();
    _rewardTransactionController.dispose();
    super.dispose();
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        spacing: 12,
                        children: [
                          const Text(
                            'Rewarded S2S example',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            controller: _userIdController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Backend user ID',
                            ),
                          ),
                          TextField(
                            controller: _rewardTransactionController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Client reward reference',
                              suffixIcon: IconButton(
                                tooltip: 'Generate new reference',
                                onPressed: () {
                                  _rewardTransactionController.text =
                                      _newRewardTransactionId();
                                },
                                icon: const Icon(Icons.refresh),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed:
                                () => updateStatus(
                                  () => loadRewardedS2S(
                                    userId: _userIdController.text.trim(),
                                    rewardTransactionId:
                                        _rewardTransactionController.text
                                            .trim(),
                                  ),
                                ),
                            child: const Text('Load Rewarded with S2S Data'),
                          ),
                          ElevatedButton(
                            onPressed:
                                () => updateStatus(
                                  () => showRewardedS2S(
                                    rewardTransactionId:
                                        _rewardTransactionController.text
                                            .trim(),
                                  ),
                                ),
                            child: const Text('Show Rewarded'),
                          ),
                          TextButton(
                            onPressed: () => updateStatus(clearRewardedS2S),
                            child: const Text('Clear S2S Data'),
                          ),
                          const Text(
                            'Do not credit from the client onReward event. '
                            'Wait for the verified backend callback.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
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
