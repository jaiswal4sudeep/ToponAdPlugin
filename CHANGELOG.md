# 📄 Changelog

All notable changes to this project will be documented in this file.

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
