import 'package:topon_ad_plugin/topon_ad_plugin.dart';

mixin ToponAdHelper {
  final String appId = '<YOUR_APP_ID>';
  final String appKey = '<YOUR_APP_KEY>';

  final String interstitialId = '<INTERSTITIAL_PLACEMENT_ID>';
  final String rewardedId = '<REWARDED_PLACEMENT_ID>';
  final String bannerId = '<BANNER_PLACEMENT_ID>';
  final String splashId = '<SPLASH_PLACEMENT_ID>';
  final String nativeId = '<NATIVE_PLACEMENT_ID>';

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

  Future<String> loadRewarded() async {
    final bool result = await ToponAdPlugin.loadRewardedAd(
      placementId: rewardedId,
    );
    return result ? 'Rewarded Ad Loaded' : 'Rewarded Ad Load Failed';
  }

  Future<String> showRewarded() async {
    final bool result = await ToponAdPlugin.showRewardedAd();
    return result ? 'Rewarded Ad Shown' : 'Rewarded Ad Show Failed';
  }
}
