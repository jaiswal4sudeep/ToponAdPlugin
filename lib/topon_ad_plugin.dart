import 'package:flutter/services.dart';

/// A Flutter plugin for displaying TopOn Ads using platform channels.
class ToponAdPlugin {
  static const MethodChannel _channel = MethodChannel('topon_ad_plugin');

  /// Initializes the TopOn SDK with [appId] and [appKey].
  ///
  /// Returns `true` if the SDK was initialized successfully, else `false`.
  static Future<bool> initializeSdk({
    required String appId,
    required String appKey,
  }) async {
    try {
      return await _channel.invokeMethod('initSdk', {
        'appId': appId,
        'appKey': appKey,
      });
    } catch (e) {
      return false;
    }
  }

  /// Loads an interstitial ad using the given [placementId].
  static Future<bool> loadInterstitialAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadInterstitialAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  /// Shows a loaded interstitial ad.
  static Future<bool> showInterstitialAd() async {
    try {
      return await _channel.invokeMethod('showInterstitial');
    } catch (e) {
      return false;
    }
  }

  /// Loads a splash ad with the given [placementId].
  static Future<bool> loadSplashAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadSplashAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  /// Loads a banner ad with the given [placementId].
  static Future<bool> loadBannerAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadBannerAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  /// Destroys any loaded banner ads.
  static Future<bool> destroyBannerAd() async {
    try {
      return await _channel.invokeMethod('destroyBannerAd');
    } catch (e) {
      return false;
    }
  }

  /// Loads a native ad with the given [placementId].
  static Future<bool> loadNativeAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadNativeAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  /// Displays a previously loaded native ad.
  static Future<bool> showNativeAd() async {
    try {
      return await _channel.invokeMethod('showNativeAd');
    } catch (e) {
      return false;
    }
  }

  /// Loads a rewarded video ad with the given [placementId].
  static Future<bool> loadRewardedAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadRewardedAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  /// Shows a previously loaded rewarded video ad.
  static Future<bool> showRewardedAd() async {
    try {
      return await _channel.invokeMethod('showRewardedAd');
    } catch (e) {
      return false;
    }
  }
}
