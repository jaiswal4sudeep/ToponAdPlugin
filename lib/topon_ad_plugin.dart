import 'package:flutter/services.dart';

class ToponAdPlugin {
  static const MethodChannel _channel = MethodChannel('topon_ad_plugin');

  //! Initialize TopOn SDK
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

  //! Load Interstitial Ad
  static Future<bool> loadInterstitialAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadInterstitialAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  //! Show Interstitial Ad
  static Future<bool> showInterstitialAd() async {
    try {
      return await _channel.invokeMethod('showInterstitial');
    } catch (e) {
      return false;
    }
  }

  //! Load Splash Ad
  static Future<bool> loadSplashAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadSplashAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  //! Load Banner Ad
  static Future<bool> loadBannerAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadBannerAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  //! Destroy Banner Ad
  static Future<bool> destroyBannerAd() async {
    try {
      return await _channel.invokeMethod('destroyBannerAd');
    } catch (e) {
      return false;
    }
  }

  //! Load Native Ad
  static Future<bool> loadNativeAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadNativeAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  //! Show Native Ad
  static Future<bool> showNativeAd() async {
    try {
      return await _channel.invokeMethod('showNativeAd');
    } catch (e) {
      return false;
    }
  }

  //! Load Rewarded Video Ad
  static Future<bool> loadRewardedAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadRewardedAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  //! Show Rewarded Video Ad
  static Future<bool> showRewardedAd() async {
    try {
      return await _channel.invokeMethod('showRewardedAd');
    } catch (e) {
      return false;
    }
  }
}
