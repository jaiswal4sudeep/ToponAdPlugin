
# 📄 Changelog

All notable changes to this project will be documented in this file.

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
