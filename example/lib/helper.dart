import 'dart:convert';

import 'package:topon_ad_plugin/topon_ad_plugin.dart';

mixin ToponAdHelper {
  final String appId = 'h6803ecfae8230';
  final String appKey = 'a725a21d5665287bae35479a2d7c4eace';

  final String interstitialId = 'n6803ed48d2328';
  final String rewardedId = 'n6803ed28dc768';
  final String bannerId = 'n6803ed3480a3f';
  final String splashId = 'n6803ed564c0b7';
  final String nativeId = 'n6803ed1b15a52';

  Future<String> initializeTopon() async {
    final bool result = await ToponAdPlugin.initializeSdk(
      appId: appId,
      appKey: appKey,
    );
    return result ? 'SDK Initialized' : 'SDK Initialization Failed';
  }

  Future<String> loadInterstitial() async {
    final bool result = await ToponAdPlugin.loadInterstitialAd(
      placementId: interstitialId,
    );
    return result ? 'Interstitial Ad Loaded' : 'Interstitial Ad Load Failed';
  }

  Future<String> showInterstitial() async {
    final bool result = await ToponAdPlugin.showInterstitialAd();
    return result ? 'Interstitial Ad Shown' : 'Interstitial Ad Show Failed';
  }

  Future<String> loadSplash() async {
    final bool result = await ToponAdPlugin.loadSplashAd(placementId: splashId);
    return result ? 'Splash Ad Loaded' : 'Splash Ad Load Failed';
  }

  Future<String> loadBanner() async {
    final bool result = await ToponAdPlugin.loadBannerAd(
      placementId: bannerId,
      position: BannerPosition.bottom,
    );
    return result ? 'Banner Ad Loaded' : 'Banner Ad Load Failed';
  }

  Future<String> removeBanner() async {
    final bool result = await ToponAdPlugin.removeBannerAd();
    return result ? 'Banner Ad removed' : 'Banner Ad Remove Failed';
  }

  Future<String> loadNative() async {
    final bool result = await ToponAdPlugin.loadNativeAd(placementId: nativeId);
    return result ? 'Native Ad Loaded' : 'Native Ad Load Failed';
  }

  Future<ToponNativeAdInfo?> getNativeAdInfo() async {
    return await ToponAdPlugin.getNativeAdInfo();
  }

  Future<String> loadRewardedS2S({
    required String userId,
    required String rewardTransactionId,
  }) async {
    if (userId.trim().isEmpty || rewardTransactionId.trim().isEmpty) {
      return 'User ID and reward transaction ID are required';
    }

    // This value is returned by TopOn in the `extra_data` callback parameter.
    // Treat it as untrusted client input on your backend.
    final String customData = jsonEncode({
      'reward_transaction_id': rewardTransactionId,
      'source': 'topon_flutter_example',
    });

    final bool result = await ToponAdPlugin.loadRewardedAd(
      placementId: rewardedId,
      userId: userId,
      customData: customData,
    );
    return result
        ? 'Rewarded ad loaded with S2S data'
        : 'Rewarded ad S2S load failed';
  }

  Future<String> showRewardedS2S({required String rewardTransactionId}) async {
    final bool result = await ToponAdPlugin.showRewardedAd(
      // Returned inside `ilrd` as `show_custom_ext`. The dashboard callback
      // URL must include `ilrd={ilrd}` for this value to reach the backend.
      showCustomData: rewardTransactionId,
    );
    return result
        ? 'Rewarded ad shown; waiting for backend S2S callback'
        : 'Rewarded ad show failed';
  }

  Future<String> clearRewardedS2S() async {
    final bool result = await ToponAdPlugin.clearRewardedS2SData();
    return result
        ? 'Rewarded S2S data cleared; load a new ad'
        : 'Could not clear rewarded S2S data';
  }
}
