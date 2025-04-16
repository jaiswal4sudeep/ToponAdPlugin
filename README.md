# 📦 ToponAdPlugin (Flutter)

A lightweight Flutter plugin to integrate TopOn Ads via method channels. Supports initializing the SDK and handling Interstitial & Banner ads with ease.

---

## 🚀 Features

- ✅ Initialize TopOn SDK  
- ✅ Load and Show Interstitial Ads  
- ✅ Load Banner Ads  

---

## 📦 Installation

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  topon_ad_plugin:
    path: ./path_to_your_plugin_directory
```

> Update the path as per your local or Git structure.

---

## 🛠️ Android Setup

1. Add TopOn SDK dependencies to your `android/app/build.gradle` and `android/build.gradle`.

2. Include required permissions and metadata in `AndroidManifest.xml`.

3. Make sure Proguard rules (if enabled) are added as per TopOn's documentation.

---

## 🧑‍💻 Usage

### 1️⃣ Initialize the SDK

```dart
final success = await ToponAdPlugin.initializeSdk(
  appId: 'your_app_id',
  appKey: 'your_app_key',
  placementId: 'your_placement_id',
);
```

---

### 2️⃣ Load and Show Interstitial Ad

```dart
await ToponAdPlugin.loadAd(placementId: 'your_placement_id');

final shown = await ToponAdPlugin.showAd();
```

---

### 3️⃣ Load Banner Ad

```dart
await ToponAdPlugin.loadBanner(placementId: 'your_banner_placement_id');
```

> You need to handle the platform view part natively for displaying the banner.

---

## 📄 Method Summary

| Method              | Description                          |
|---------------------|--------------------------------------|
| `initializeSdk()`   | Initializes TopOn SDK                |
| `loadAd()`          | Loads interstitial ad                |
| `showAd()`          | Shows the loaded interstitial ad     |
| `loadBanner()`      | Loads a banner ad                    |

---

## 📂 Plugin Code

```dart
import 'package:flutter/services.dart';

class ToponAdPlugin {
  static const MethodChannel _channel = MethodChannel('topon_ad_plugin');

  static Future<bool> initializeSdk({
    required String appId,
    required String appKey,
    required String placementId,
  }) async {
    try {
      return await _channel.invokeMethod('initializeSdk', {
        'appId': appId,
        'appKey': appKey,
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> loadAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> showAd() async {
    try {
      return await _channel.invokeMethod('showAd');
    } catch (e) {
      return false;
    }
  }

  static Future<bool> loadBanner({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadBanner', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }
}
```

---

## 📞 MethodChannel Mapping (Native Side)

| Dart Method     | Android Native Call       |
|----------------|----------------------------|
| `initializeSdk` | Initialize TopOn SDK      |
| `loadAd`        | Load Interstitial Ad      |
| `showAd`        | Show Loaded Interstitial  |
| `loadBanner`    | Load and Display Banner   |

---

## 🧪 Testing Tips

- Use real `appId`, `appKey`, and `placementId` from TopOn dashboard.
- Test on a real device for accurate ad behavior.

---

## 📃 License

MIT License. Free to use, modify, and distribute.