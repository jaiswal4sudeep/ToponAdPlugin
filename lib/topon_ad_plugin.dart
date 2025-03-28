import 'package:flutter/services.dart';

class ToponAdPlugin {
  static const MethodChannel _channel = MethodChannel('topon_ad_plugin');

  static Future<bool> initializeSdk({
    required String appId,
    required String appKey,
    required String placementId,
  }) async {
    try {
      return await _channel.invokeMethod('initializeSdk', {
        'appId': appId,
        'appKey': appKey,
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> loadAd({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadAd', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> showAd() async {
    try {
      return await _channel.invokeMethod('showAd');
    } catch (e) {
      return false;
    }
  }

  static Future<bool> loadBanner({required String placementId}) async {
    try {
      return await _channel.invokeMethod('loadBanner', {
        'placementId': placementId,
      });
    } catch (e) {
      return false;
    }
  }
}
