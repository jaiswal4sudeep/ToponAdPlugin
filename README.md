
# 📦 ToponAdPlugin (Flutter)

A lightweight Flutter plugin to integrate [TopOn Ads](https://www.toponad.com/) using method channels.  
This plugin provides simple methods to initialize the SDK and display **Interstitial**, **Rewarded**, **Native**, **Banner**, and **Splash** ads in your Flutter apps.

> 🔗 GitHub: [https://github.com/jaiswal4sudeep/ToponAdPlugin](https://github.com/jaiswal4sudeep/ToponAdPlugin)

---

## 🚀 Features

- ✅ Initialize TopOn SDK  
- ✅ Load & Show Interstitial Ads  
- ✅ Load & Show Rewarded Ads  
- ✅ Load Native Ads and render custom Flutter widgets  
- ✅ Load Banner Ads  
- ✅ Load Splash Ads  
- ✅ Listen to Ad Events from Native Side  

---

## 📦 Installation

Add this plugin to your `pubspec.yaml`:

```yaml
dependencies:
  topon_ad_plugin:
    git:
      url: https://github.com/jaiswal4sudeep/ToponAdPlugin.git
```

---

## 🛠️ Android Setup

1. **Add TopOn SDK dependencies**:  
Follow the official TopOn [Android integration guide](https://docs.toponad.com/#/en-us/android/stepbystep).

2. **Update your `AndroidManifest.xml`**:
   - Add necessary permissions
   - Include required meta-data tags from TopOn

3. **Add Proguard Rules** (if using Proguard)

---

## 🧑‍💻 Usage

### 0️⃣ Set Up Ad Event Listeners (Optional)

Call this once during app startup to listen to ad lifecycle events from native code.

```dart
ToponAdPlugin.setUpListeners((event, args) {
  print('Ad Event: \$event, Data: \$args');
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

### 4️⃣ Native Ads (Self-Rendering)

```dart
await ToponAdPlugin.loadNativeAd(placementId: 'your_native_id');
final nativeAdInfo = await ToponAdPlugin.getNativeAdInfo();
if (nativeAdInfo != null) {
  print(nativeAdInfo.title);
  // Render your custom native ad widget
}
```

---

### 5️⃣ Banner Ads

```dart
await ToponAdPlugin.loadBannerAd(
  placementId: 'your_banner_id',
  position: BannerPosition.bottom,
);
```

> ⚡ Note: Banner ads auto-render at top or bottom based on the provided position.

---

### 6️⃣ Splash Ads

```dart
await ToponAdPlugin.loadSplashAd(placementId: 'your_splash_id');
```

---

## 🧪 Testing Tips

- Use real `appId`, `appKey`, and `placementId` from the TopOn dashboard.
- Always test ad behavior on a real device (not emulator).

---

## 📃 License

MIT License. Free to use, modify, and distribute.
