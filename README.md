# 📦 ToponAdPlugin (Flutter)

A lightweight Flutter plugin to integrate [TopOn Ads](https://www.toponad.com/) using method channels. This plugin provides simple methods to initialize the SDK and display **Interstitial**, **Rewarded**, **Native**, **Banner**, and **Splash** ads in your Flutter apps.

> 🔗 GitHub: [https://github.com/jaiswal4sudeep/ToponAdPlugin](https://github.com/jaiswal4sudeep/ToponAdPlugin)

---

## 🚀 Features

- ✅ Initialize TopOn SDK  
- ✅ Load & Show Interstitial Ads  
- ✅ Load & Show Rewarded Ads  
- ✅ Load & Show Native Ads  
- ✅ Load Banner Ads  
- ✅ Load Splash Ads  
- ✅ Listen to Ad Events  

---

## 📦 Installation

Add this plugin to your `pubspec.yaml` file:

```yaml
dependencies:
  topon_ad_plugin:
    path: https://github.com/jaiswal4sudeep/ToponAdPlugin.git
```

---

## 🛠️ Android Setup

1. **Add TopOn SDK dependencies** to your `android/build.gradle` and `android/app/build.gradle` files as per [TopOn’s official documentation](https://docs.toponad.com/#/en-us/android/stepbystep).

2. **Update your `AndroidManifest.xml`**:
   - Add necessary permissions.
   - Include required meta-data tags.

3. **Add Proguard rules** (if you’re using Proguard).

---

## 🧑‍💻 Usage

### 0️⃣ Set Up Ad Event Listeners (Optional)

Call this once during app startup to listen to ad lifecycle events from native code.

```dart
ToponAdPlugin.setUpListeners((event, args) {
  print('Ad Event: $event, Data: $args');
});
```

---

### 1️⃣ Initialize SDK

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

### 5️⃣ Banner Ads

```dart
await ToponAdPlugin.loadBannerAd(placementId: 'your_banner_id');
```

> You need to implement native view rendering for banners on both platforms.

---

### 6️⃣ Splash Ads

```dart
await ToponAdPlugin.loadSplashAd(placementId: 'your_splash_id');
```

---

## 🧪 Testing Tips

- Use real `appId`, `appKey`, and `placementId` from the TopOn dashboard.
- Always test ad behavior on a real device.

---

## 📃 License

MIT License. Free to use, modify, and distribute.