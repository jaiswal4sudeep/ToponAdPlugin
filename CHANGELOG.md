
# 📄 Changelog

All notable changes to this project will be documented in this file.

---

## [0.0.14] - 2026-10-31

### 🍎 Added
- **Full iOS Platform Support**: Integrated native iOS support via TopOn (AnyThink) SDK with complete feature parity to Android.
  - Added native Objective-C implementation (`ToponAdPlugin.h`, `ToponAdPlugin.m`) and CocoaPods specification (`topon_ad_plugin.podspec`).
  - Added support for all ad formats on iOS:
    - **Interstitial Ads** (`loadInterstitialAd`, `showInterstitial`)
    - **Rewarded Video Ads** (`loadRewardedAd`, `showRewardedAd`) with Server-to-Server (S2S) verification data (`userId`, `customData`) and display-time custom data (`showCustomData`)
    - **Banner Ads** (`loadBannerAd`, `removeBannerAd`) with safe area layout constraints and top/bottom positioning
    - **Native Ads (Self-Rendering)** (`loadNativeAd`, `getNativeAdInfo`) mapping all asset fields to `ToponNativeAdInfo`
    - **Splash Ads** (`loadSplashAd`) with auto-display on readiness
  - Implemented decoupled delegate listeners for each ad format (`ToponInterstitialDelegate`, `ToponRewardedVideoDelegate`, `ToponBannerDelegate`, `ToponSplashDelegate`, `ToponNativeDelegate`) to prevent callback collisions.

### 📚 Documentation & Examples
- Added comprehensive [IOS_SETUP_GUIDE.md](IOS_SETUP_GUIDE.md) covering CocoaPods adapter configuration (AdMob, Meta, Vungle, InMobi, etc.), `Info.plist` keys (ATT, ATS, SKAdNetworkItems), App Tracking Transparency authorization flow, and troubleshooting.
- Updated `README.md` with iOS setup instructions.
- Added iOS runner setup and platform-aware helper getters to the example project.

---

## [0.0.13] - 2026-09-30

- Added rewarded-ad S2S postback metadata support (`userId` and `customData`).
- Added APIs to set and clear rewarded S2S data safely across login changes.
- Rewarded S2S data can be supplied while loading; display-time custom data is
  supported through TopOn's `show_custom_ext` field.

---

[0.0.12] - 2026-07-13
### 🛠️ Updates

- Upgraded all integrated Ad SDKs to their latest stable versions for improved performance and compatibility.

---

[0.0.11] - 2026-07-13
### 🛠️ Updates

- Upgraded all integrated Ad SDKs to their latest stable versions for improved performance and compatibility.

---

[0.0.10] - 2025-09-26
### 🔌 Added

- Added support for **InMobi** ad network adapter to enhance mediation capabilities.

### 🛠️ Updates

- Upgraded all integrated Ad SDKs to their latest stable versions for improved performance and compatibility.

---

[0.0.9] - 2025-08-17
### 🚀 Updates

- Upgraded all integrated Ad SDKs to their latest stable versions for enhanced performance and compatibility:
  - ✅ **TopOn SDK** upgraded
  - ✅ **AdMob Adapter** updated
  - ✅ **Facebook (Meta Audience Network) Adapter** updated
  - ✅ **UnityAds Adapter** updated
  - ✅ **IronSource Adapter** updated
  - ✅ **AppLovin Adapter** updated
  - ✅ **Mintegral Adapter** updated
  - ✅ **Vungle Adapter** updated

---

## [0.0.8] - 2025-06-30

### 🚀 Updates
- Upgraded all integrated **Ads SDKs** to their latest stable versions for improved performance and compatibility:
  - ✅ **TopOn SDK** upgraded
  - ✅ **AdMob Adapter** updated
  - ✅ **Facebook (Meta Audience Network) Adapter** updated
  - ✅ **UnityAds Adapter** updated
  - ✅ **IronSource Adapter** updated
  - ✅ **AppLovin Adapter** updated
  - ✅ **Mintegral Adapter** updated
  - ✅ **Vungle Adapter** updated

### 🛠️ Improvements
- Ensured compatibility with latest Android dependencies.
- Verified stability of native ad lifecycle after SDK updates.

---

## [0.0.7] - 2025-04-27

### 🔥 Major Changes
- Replaced `showNativeAd()` with `getNativeAdInfo()` method for better self-rendered native ad control.
- Introduced `ToponNativeAdInfo` Dart class for strongly-typed native ad information.
- Added full native ad lifecycle event listeners (Impression, Click, Close, Video Start, Video End).

### 🛠️ Improvements
- Cleaned up Flutter plugin code with better documentation and null safety.
- Updated `README.md` to match new native ad integration flow.

---

## [0.0.6] - 2025-04-25

### 🐞 Fixed
- Resolved `IllegalStateException: Reply already submitted` crash.
- Ensured `MethodChannel.Result.success()` is called only once per method invocation.
- Added guards (`pendingInterstitialResult`, `pendingRewardedResult`) to prevent multiple replies from asynchronous ad callbacks.

---

## [0.0.5] - 2025-04-24

### 🔌 Added
- Integrated multiple ad network adapters to enable full mediation support:
  - ✅ AdMob
  - ✅ Facebook (Meta Audience Network)
  - ✅ UnityAds
  - ✅ IronSource
  - ✅ AppLovin
  - ✅ Mintegral

### 📦 Updated
- Updated core TopOn SDK and related dependencies to version `6.4.80`.

---

## [0.0.4] - 2025-04-21

### 🛠️ Fixed
- Resolved crash due to re-adding banner view (`IllegalStateException: The specified child already has a parent`).
- Banner ads now properly recreate `TUBannerView` and handle removal/reloading without errors.

---

## [0.0.3] - 2025-04-20

### ✨ Added
- `setUpListeners()` method to receive ad events from native.
- `onEvent` callback to handle ad event responses in Dart.

### 📚 Improved
- Readme updated with usage of `setUpListeners()`.

---

## [0.0.2] - 2025-04-20

### 📚 Added
- Documentation comments to all public API methods for better clarity and IDE hints.

### 🧹 Fixed
- Minor code cleanup, conventions, and linting improvements.

---

## [0.0.1] - 2025-04-20

### 🚀 Initial Release
- Flutter plugin for integrating TopOn Ads using method channels.
- Support for:  
  - Interstitial Ads  
  - Rewarded Ads  
  - Native Ads  
  - Banner Ads  
  - Splash Ads
