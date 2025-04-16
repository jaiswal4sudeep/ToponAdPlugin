import 'package:flutter/material.dart';
import 'package:topon_ad_plugin/topon_ad_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin Example App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final bool init = await ToponAdPlugin.initializeSdk(
                    appId: '<APP_ID>',
                    appKey: '<APP_KEY>',
                    placementId: '<PLACEMENT_ID>',
                  );
                  setState(() {
                    status =
                        init
                            ? 'Topon SDK Initialized Successfully'
                            : 'Topon SDK Initialization Failed';
                  });
                },
                child: Text('Initialize SDK'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final bool load = await ToponAdPlugin.loadAd(
                    placementId: '<PLACEMENT_ID>',
                  );
                  setState(() {
                    status =
                        load ? 'Ads Loaded Successfully' : 'Ads Loaded Failed';
                  });
                },
                child: Text('Load Ads'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final bool show = await ToponAdPlugin.showAd();
                  setState(() {
                    status = show ? 'Ad Shown Successfully' : 'Ad Shown Failed';
                  });
                },
                child: Text('Show Ads'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final bool loadBanner = await ToponAdPlugin.loadBanner(
                    placementId: 'n67e3c8bf72ac6',
                  );
                  setState(() {
                    status =
                        loadBanner
                            ? 'Banner Shown Successfully'
                            : 'Banner Shown Failed';
                  });
                },
                child: Text('Show Banner'),
              ),
              Text(status),
            ],
          ),
        ),
      ),
    );
  }
}
