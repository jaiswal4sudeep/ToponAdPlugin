import 'package:flutter/services.dart';

/// A Flutter plugin for displaying TopOn Ads using platform channels.
///
/// This plugin supports various ad formats such as interstitial,
/// rewarded video, splash, banner, and native ads. It also allows listening
/// to ad lifecycle events from the native side.
class ToponAdPlugin {
  static const MethodChannel _channel = MethodChannel('topon_ad_plugin');

  /// Callback to listen to native ad events.
  ///
  /// Example:
  /// ```dart
  /// ToponAdPlugin.onEvent = (method, arguments) {
  ///   if (method == 'onRewardedAdCompleted') {
  ///     // Reward the user
  ///   }
  /// };
  /// ```
  static void Function(String method, dynamic arguments)? onEvent;

  /// Initializes the TopOn SDK with the given [appId] and [appKey].
  ///
  /// Returns `true` if initialization is successful, otherwise `false`.
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

  /// Sets up a listener to receive ad events from the native side.
  ///
  /// Call this once during app startup before loading or showing any ads.
  static void setUpListeners() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (onEvent != null) {
        onEvent!(call.method, call.arguments);
      }
    });
  }

  /// Loads an interstitial ad for the provided [placementId].
  static Future<bool> loadInterstitialAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadInterstitialAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  /// Shows a previously loaded interstitial ad.
  static Future<bool> showInterstitialAd() async {
    try {
      return await _channel.invokeMethod('showInterstitial');
    } catch (e) {
      return false;
    }
  }

  /// Loads a splash ad for the provided [placementId].
  static Future<bool> loadSplashAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadSplashAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  /// Loads a banner ad for the provided [placementId].
  static Future<bool> loadBannerAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadBannerAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  /// Destroys any currently displayed banner ad.
  static Future<bool> destroyBannerAd() async {
    try {
      return await _channel.invokeMethod('destroyBannerAd');
    } catch (e) {
      return false;
    }
  }

  /// Loads a native ad for the provided [placementId].
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

  /// Loads a rewarded video ad for the provided [placementId].
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
