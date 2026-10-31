
# 📦 ToponAdPlugin (Flutter)

A lightweight Flutter plugin to integrate [TopOn Ads](https://www.toponad.com/) using method channels.  
This plugin provides simple methods to initialize the SDK and display **Interstitial**, **Rewarded**, **Native**, **Banner**, and **Splash** ads in your Flutter apps.

> 🔗 GitHub: [https://github.com/jaiswal4sudeep/ToponAdPlugin](https://github.com/jaiswal4sudeep/ToponAdPlugin)

---

## 🚀 Features

- ✅ Initialize TopOn SDK  
- ✅ Load & Show Interstitial Ads  
- ✅ Load & Show Rewarded Ads  
- ✅ Server-to-server (S2S) rewarded postback data
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
   - Add necessary permissions (`INTERNET`, `ACCESS_NETWORK_STATE`, etc.)
   - Include required meta-data tags from TopOn

3. **Add Proguard Rules** (if using Proguard / R8)

---

## 🍎 iOS Setup

Detailed guide with complete examples: 👉 **[IOS_SETUP_GUIDE.md](IOS_SETUP_GUIDE.md)**

1. **Minimum Target:** iOS 12.0+
2. **Configure `ios/Podfile`:**
   Add required network adapters in your Flutter project's `ios/Podfile`:
   ```ruby
   target 'Runner' do
     use_frameworks!
     use_modular_headers!

     flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

     # TopOn Adapters (Add what your mediation waterfall needs):
     pod 'AnyThinkiOS/AnyThinkAdmobAdapter'
     pod 'AnyThinkiOS/AnyThinkFacebookAdapter'
     pod 'AnyThinkiOS/AnyThinkVungleAdapter'
     pod 'AnyThinkiOS/AnyThinkInmobiAdapter'
   end

   post_install do |installer|
     installer.pods_project.targets.each do |target|
       flutter_additional_ios_build_settings(target)
       target.build_configurations.each do |config|
         config.build_settings['OTHER_LDFLAGS'] ||= ['$(inherited)', '-ObjC']
       end
     end
   end
   ```
3. **Configure `ios/Runner/Info.plist`:**
   - **App Tracking Transparency (ATT):** Add `NSUserTrackingUsageDescription`
   - **App Transport Security (ATS):** Add `NSAllowsArbitraryLoads = true`
   - **SKAdNetwork:** Add `SKAdNetworkItems` for attribution tracking (see [IOS_SETUP_GUIDE.md](IOS_SETUP_GUIDE.md)).
4. **Install Pods:**
   ```bash
   cd ios && pod install --repo-update && cd ..
   ```

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
await ToponAdPlugin.loadRewardedAd(
  placementId: 'your_rewarded_id',
  userId: currentUser.id, // Your backend's stable user ID
  customData: rewardTransactionId, // Optional opaque value
);
final shown = await ToponAdPlugin.showRewardedAd();
```

### Rewarded S2S postbacks

Enable and configure the rewarded-video server callback URL for the placement
in the TopOn dashboard. The plugin passes `userId` and `customData` to the
TopOn SDK; TopOn then includes them in the postback to your backend.

See the example app's [S2S backend setup](example/S2S_BACKEND_SETUP.md) for the
complete callback URL, signature verification formula, response codes, and
reward-processing checklist.

You can set the values separately when the user signs in:

```dart
await ToponAdPlugin.setRewardedS2SData(
  userId: currentUser.id,
  customData: rewardTransactionId,
);

// S2S data is attached to the ad at load time.
await ToponAdPlugin.loadRewardedAd(placementId: 'your_rewarded_id');
await ToponAdPlugin.showRewardedAd();

// Prevent one user's data being reused after logout.
await ToponAdPlugin.clearRewardedS2SData();
```

Changing or clearing S2S data invalidates an already-loaded rewarded ad. Load a
new ad afterward; this prevents cached reward metadata crossing user sessions.

Display-time custom data can be sent separately using TopOn's
`show_custom_ext` field:

```dart
await ToponAdPlugin.showRewardedAd(
  showCustomData: rewardTransactionId,
);
```

For display-time data, add `&ilrd={ilrd}` to the callback URL configured in the
TopOn dashboard and parse `show_custom_ext` from the returned `ilrd` payload.
The stable `userId` must still be supplied before loading the ad.

Your backend should verify TopOn's callback signature and process each callback
idempotently (for example, using the callback transaction ID) before crediting
the reward. Do not put secrets in `customData`; it originates on the client.

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
