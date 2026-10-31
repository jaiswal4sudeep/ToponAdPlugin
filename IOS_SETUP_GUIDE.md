# 🍎 iOS Setup Guide for TopOn SDK (topon_ad_plugin)

This document provides a comprehensive step-by-step setup guide for integrating and displaying **TopOn (AnyThink)** ads in your Flutter iOS application.

Official TopOn iOS SDK Portal: [https://portal.toponad.net/m/sdk/download?type=iOS](https://portal.toponad.net/m/sdk/download?type=iOS)

---

## 📋 Requirements
- **iOS Deployment Target:** iOS 12.0 or higher
- **Xcode:** 14.0 or higher
- **CocoaPods:** 1.11.0 or higher
- **TopOn Dashboard Account:** App ID, App Key, and Placement IDs for iOS

---

## 🛠️ Step 1: Configure `ios/Podfile`

The `topon_ad_plugin` automatically integrates the core **`AnyThinkiOS`** mediation SDK. To display ads from third-party networks (AdMob, Meta, Vungle, etc.), you need to declare the corresponding TopOn network adapters in your Flutter project's `ios/Podfile`.

Open `ios/Podfile` and configure it as shown below:

```ruby
platform :ios, '12.0'

# CocoaPods configuration
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

  # -------------------------------------------------------------
  # 🌐 TopOn Network Adapters (Select networks used in waterfall)
  # -------------------------------------------------------------
  
  # Google AdMob
  pod 'AnyThinkiOS/AnyThinkAdmobAdapter'
  
  # Meta / Facebook Audience Network
  pod 'AnyThinkiOS/AnyThinkFacebookAdapter'
  
  # Liftoff / Vungle
  pod 'AnyThinkiOS/AnyThinkVungleAdapter'
  
  # InMobi
  pod 'AnyThinkiOS/AnyThinkInmobiAdapter'
  
  # AppLovin
  # pod 'AnyThinkiOS/AnyThinkApplovinAdapter'
  
  # Mintegral
  # pod 'AnyThinkiOS/AnyThinkMintegralAdapter'
  
  # Pangle
  # pod 'AnyThinkiOS/AnyThinkPangleAdapter'
  
  # Unity Ads
  # pod 'AnyThinkiOS/AnyThinkUnityAdsAdapter'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      # TopOn & third-party SDKs require the -ObjC linker flag
      config.build_settings['OTHER_LDFLAGS'] ||= ['$(inherited)', '-ObjC']
    end
  end
end
```

Then, run:
```bash
cd ios
pod install --repo-update
cd ..
```

---

## ⚙️ Step 2: Configure `ios/Runner/Info.plist`

Open `ios/Runner/Info.plist` and add the required configurations:

### 1. App Tracking Transparency (ATT) Permission
Required by Apple on iOS 14+ to track users for ad personalization:
```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

### 2. App Transport Security (ATS)
Many ad networks load creative assets (images/videos) over HTTP:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 3. Google AdMob App ID (If using AdMob)
If integrating Google AdMob via TopOn adapter, add your AdMob iOS App ID:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string> <!-- Sample Test App ID -->
```

### 4. SKAdNetwork Items (Crucial for iOS 14+ Ad Attribution)
Add SKAdNetwork identifiers for TopOn and supported ad networks. You can copy the complete SKAdNetwork list from the [TopOn SKAdNetwork Guide](https://portal.toponad.net/m/sdk/download?type=iOS) or use this standard set:

```xml
<key>SKAdNetworkItems</key>
<array>
    <!-- TopOn / AnyThink -->
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>mlmmfzh3r3.skadnetwork</string>
    </dict>
    <!-- Google AdMob -->
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>cstr6suwn9.skadnetwork</string>
    </dict>
    <!-- Meta / Facebook -->
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>v9wttpbfk9.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>n38lu8286q.skadnetwork</string>
    </dict>
    <!-- Liftoff / Vungle -->
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>gta9lk7p23.skadnetwork</string>
    </dict>
    <!-- InMobi -->
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>wzmmz9fp6w.skadnetwork</string>
    </dict>
    <!-- AppLovin -->
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>ludvb6z3bs.skadnetwork</string>
    </dict>
    <!-- Mintegral -->
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>kbd7576wx3.skadnetwork</string>
    </dict>
    <!-- Pangle -->
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>22mmun2rn5.skadnetwork</string>
    </dict>
</array>
```

---

## 🎯 Step 3: Request ATT Tracking Authorization in Flutter

For highest eCPM and fill rate on iOS 14.5+, request tracking authorization before initializing TopOn SDK.

Add `app_tracking_transparency` to your Flutter app:
```yaml
dependencies:
  app_tracking_transparency: ^2.0.5
```

In your Flutter app startup (`main.dart`):
```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:topon_ad_plugin/topon_ad_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isIOS) {
    // Request tracking permission on iOS 14+
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    print('ATT Tracking Status: $status');
  }

  // Set up ad lifecycle listeners
  ToponAdPlugin.setUpListeners();
  ToponAdPlugin.onEvent = (method, args) {
    print('TopOn Event: $method | Args: $args');
  };

  // Initialize TopOn SDK with iOS IDs
  final success = await ToponAdPlugin.initializeSdk(
    appId: Platform.isIOS ? 'YOUR_IOS_APP_ID' : 'YOUR_ANDROID_APP_ID',
    appKey: Platform.isIOS ? 'YOUR_IOS_APP_KEY' : 'YOUR_ANDROID_APP_KEY',
  );

  runApp(const MyApp());
}
```

---

## 📱 Step 4: Ad Format Examples (iOS & Android Compatible)

### 1. Interstitial Ads
```dart
// Load Interstitial
final loaded = await ToponAdPlugin.loadInterstitialAd(
  placementId: Platform.isIOS ? 'YOUR_IOS_INTERSTITIAL_ID' : 'YOUR_ANDROID_INTERSTITIAL_ID',
);

// Show Interstitial
if (loaded) {
  final shown = await ToponAdPlugin.showInterstitialAd();
}
```

### 2. Rewarded Video Ads (With S2S Verification)
```dart
// Load Rewarded with optional S2S backend tracking
final loaded = await ToponAdPlugin.loadRewardedAd(
  placementId: Platform.isIOS ? 'YOUR_IOS_REWARDED_ID' : 'YOUR_ANDROID_REWARDED_ID',
  userId: 'user_12345',
  customData: '{"transaction_id":"tx_abc_123"}',
);

// Show Rewarded
if (loaded) {
  await ToponAdPlugin.showRewardedAd(
    showCustomData: 'optional_display_metadata',
  );
}
```

### 3. Banner Ads
```dart
// Load Banner (Auto-renders at top or bottom with iOS Safe Area support)
await ToponAdPlugin.loadBannerAd(
  placementId: Platform.isIOS ? 'YOUR_IOS_BANNER_ID' : 'YOUR_ANDROID_BANNER_ID',
  position: BannerPosition.bottom, // or BannerPosition.top
);

// Remove Banner when leaving screen
await ToponAdPlugin.removeBannerAd();
```

### 4. Native Ads (Self-Rendering)
```dart
// 1. Request Native Ad
await ToponAdPlugin.loadNativeAd(
  placementId: Platform.isIOS ? 'YOUR_IOS_NATIVE_ID' : 'YOUR_ANDROID_NATIVE_ID',
);

// 2. Fetch Ad Info
final nativeAdInfo = await ToponAdPlugin.getNativeAdInfo();
if (nativeAdInfo != null) {
  print('Ad Title: ${nativeAdInfo.title}');
  print('Ad CTA: ${nativeAdInfo.callToAction}');
  print('Icon URL: ${nativeAdInfo.iconUrl}');
  print('Main Image: ${nativeAdInfo.mainImageUrl}');
  // Render custom Flutter UI using these assets
}
```

### 5. Splash / App Open Ads
```dart
// Load and display Splash Ad on app startup
await ToponAdPlugin.loadSplashAd(
  placementId: Platform.isIOS ? 'YOUR_IOS_SPLASH_ID' : 'YOUR_ANDROID_SPLASH_ID',
);
```

---

## 🧩 Network Adapters Reference Table

| Ad Network | Android Dependency (`build.gradle`) | iOS CocoaPods Subspec (`Podfile`) |
| :--- | :--- | :--- |
| **TopOn Core** | `com.thinkup.sdk:core-tpn` | `pod 'AnyThinkiOS'` *(Included by default)* |
| **Google AdMob** | `adapter-tpn-admob` | `pod 'AnyThinkiOS/AnyThinkAdmobAdapter'` |
| **Meta (Facebook)** | `adapter-tpn-facebook` | `pod 'AnyThinkiOS/AnyThinkFacebookAdapter'` |
| **Liftoff (Vungle)** | `adapter-tpn-vungle` | `pod 'AnyThinkiOS/AnyThinkVungleAdapter'` |
| **InMobi** | `adapter-tpn-inmobi` | `pod 'AnyThinkiOS/AnyThinkInmobiAdapter'` |
| **AppLovin** | `adapter-tpn-applovin` | `pod 'AnyThinkiOS/AnyThinkApplovinAdapter'` |
| **Mintegral** | `adapter-tpn-mintegral` | `pod 'AnyThinkiOS/AnyThinkMintegralAdapter'` |
| **Pangle** | `adapter-tpn-pangle` | `pod 'AnyThinkiOS/AnyThinkPangleAdapter'` |
| **Unity Ads** | `adapter-tpn-unityads` | `pod 'AnyThinkiOS/AnyThinkUnityAdsAdapter'` |

---

## 🔍 Troubleshooting & FAQs

### 1. `unrecognized selector sent to instance` crash
- **Cause:** Missing `-ObjC` flag in Xcode linker settings.
- **Fix:** Ensure the `post_install` block in `ios/Podfile` includes `config.build_settings['OTHER_LDFLAGS'] ||= ['$(inherited)', '-ObjC']`, then re-run `pod install`.

### 2. Banner ad overlaps iOS status bar or home indicator
- The plugin automatically utilizes `safeAreaLayoutGuide` on iOS so top banners avoid the notch/Dynamic Island and bottom banners stay above the home indicator.

### 3. Ads not filling on iOS Simulator
- Many ad networks (e.g. Meta Audience Network) do not serve ads on iOS Simulator. Always test on a physical iOS device with registered test device IDs in the respective network dashboard.

### 4. CocoaPods dependency resolution error
- Run:
  ```bash
  cd ios
  pod repo update
  pod deintegrate
  pod install
  cd ..
  ```
