# 📦 ToponAdPlugin (Flutter)

A lightweight Flutter plugin to integrate TopOn Ads via method channels. Supports initializing the SDK and handling Interstitial, Rewarded, Native, Banner, and Splash ads with ease.

---

## 🚀 Features

- ✅ Initialize TopOn SDK  
- ✅ Load and Show Interstitial Ads  
- ✅ Load and Show Rewarded Ads  
- ✅ Load and Show Native Ads  
- ✅ Load Banner Ads  
- ✅ Load Splash Ads  

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
);
```

---

### 2️⃣ Interstitial Ads

```dart
await ToponAdPlugin.loadInterstitialAd(placementId: 'your_interstitial_id');
final shown = await ToponAdPlugin.showInterstitialAd();
```

---

### 3️⃣ Rewarded Ads

```dart
await ToponAdPlugin.loadRewardedAd(placementId: 'your_rewarded_id');
final shown = await ToponAdPlugin.showRewardedAd();
```

---

### 4️⃣ Native Ads

```dart
await ToponAdPlugin.loadNativeAd(placementId: 'your_native_id');
final shown = await ToponAdPlugin.showNativeAd();
```

---

### 5️⃣ Banner Ad

```dart
await ToponAdPlugin.loadBannerAd(placementId: 'your_banner_id');
```

> You need to handle the platform view part natively for displaying the banner.

---

### 6️⃣ Splash Ad

```dart
await ToponAdPlugin.loadSplashAd(placementId: 'your_splash_id');
```

---

## 📄 Method Summary

| Method                     | Description                          |
|---------------------------|--------------------------------------|
| `initializeSdk()`         | Initializes TopOn SDK                |
| `loadInterstitialAd()`    | Loads interstitial ad                |
| `showInterstitialAd()`    | Shows the loaded interstitial ad     |
| `loadRewardedAd()`        | Loads rewarded ad                    |
| `showRewardedAd()`        | Shows the rewarded ad                |
| `loadNativeAd()`          | Loads native ad                      |
| `showNativeAd()`          | Shows native ad                      |
| `loadBannerAd()`          | Loads banner ad                      |
| `destroyBannerAd()`       | Destroys banner ad                   |
| `loadSplashAd()`          | Loads splash ad                      |

---

## 📂 Plugin Code

```dart
import 'package:flutter/services.dart';

class ToponAdPlugin {
  static const MethodChannel _channel = MethodChannel('topon_ad_plugin');

  static Future<bool> initializeSdk({
    required String appId,
    required String appKey,
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

  static Future<bool> loadInterstitialAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadInterstitialAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> showInterstitialAd() async {
    try {
      return await _channel.invokeMethod('showInterstitialAd');
    } catch (e) {
      return false;
    }
  }

  static Future<bool> loadRewardedAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadRewardedAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> showRewardedAd() async {
    try {
      return await _channel.invokeMethod('showRewardedAd');
    } catch (e) {
      return false;
    }
  }

  static Future<bool> loadNativeAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadNativeAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> showNativeAd() async {
    try {
      return await _channel.invokeMethod('showNativeAd');
    } catch (e) {
      return false;
    }
  }

  static Future<bool> loadBannerAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadBannerAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> destroyBannerAd() async {
    try {
      return await _channel.invokeMethod('destroyBannerAd');
    } catch (e) {
      return false;
    }
  }

  static Future<bool> loadSplashAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadSplashAd', {
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

| Dart Method           | Android Native Call       |
|----------------------|----------------------------|
| `initializeSdk`       | Initialize TopOn SDK      |
| `loadInterstitialAd`  | Load Interstitial Ad      |
| `showInterstitialAd`  | Show Interstitial Ad      |
| `loadRewardedAd`      | Load Rewarded Ad          |
| `showRewardedAd`      | Show Rewarded Ad          |
| `loadNativeAd`        | Load Native Ad            |
| `showNativeAd`        | Show Native Ad            |
| `loadBannerAd`        | Load Banner Ad            |
| `destroyBannerAd`     | Destroy Banner Ad         |
| `loadSplashAd`        | Load Splash Ad            |

---

## 🧪 Testing Tips

- Use real `appId`, `appKey`, and `placementId` from TopOn dashboard.
- Test on a real device for accurate ad behavior.

---

## 📃 License

MIT License. Free to use, modify, and distribute.