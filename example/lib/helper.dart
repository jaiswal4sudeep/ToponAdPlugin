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
