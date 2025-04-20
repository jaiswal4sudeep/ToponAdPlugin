package com.sudeep.topon_ad_plugin;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;

import com.thinkup.banner.api.TUBannerListener;
import com.thinkup.banner.api.TUBannerView;
import com.thinkup.core.api.TUAdInfo;
import com.thinkup.core.api.AdError;
import com.thinkup.core.api.TUSDK;
import com.thinkup.rewardvideo.api.TURewardVideoAd;
import com.thinkup.rewardvideo.api.TURewardVideoListener;
import com.thinkup.interstitial.api.TUInterstitial;
import com.thinkup.interstitial.api.TUInterstitialListener;
import com.thinkup.nativead.api.TUNative;
import com.thinkup.nativead.api.NativeAd;
import com.thinkup.nativead.api.TUNativeNetworkListener;
import com.thinkup.splashad.api.TUSplashAd;
import com.thinkup.splashad.api.TUSplashAdEZListener;
import com.thinkup.splashad.api.TUSplashAdExtraInfo;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class ToponAdPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Context context;
  private Activity activity;
  private TUInterstitial interstitialAd;
  private TUSplashAd splashAd;
  private TUBannerView bannerView;
  private TUNative tuNative;
  private NativeAd nativeAd;
  private TURewardVideoAd rewardedVideoAd;

  private static final String TAG = "ToponAdPlugin";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "topon_ad_plugin");
    channel.setMethodCallHandler(this);
    context = binding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "initSdk":
        initSdk(call, result);
        break;
      case "loadInterstitialAd":
        loadInterstitialAd(call, result);
        break;
      case "showInterstitial":
        showInterstitial(result);
        break;
      case "loadSplashAd":
        loadSplashAd(call, result);
        break;
      case "loadBannerAd":
        loadBannerAd(call, result);
        break;
      case "destroyBannerAd":
        destroyBannerAd(result);
        break;
      case "loadNativeAd":
        loadNativeAd(call, result);
        break;
      case "showNativeAd":
        showNativeAd(result);
        break;
      case "loadRewardedAd":
        loadRewardedAd(call, result);
        break;
      case "showRewardedAd":
        showRewardedAd(result);
        break;
      default:
        result.notImplemented();
    }
  }

  private void sendEventToDart(String method, Object arguments) {
    if (channel != null && activity != null) {
      activity.runOnUiThread(() -> channel.invokeMethod(method, arguments));
    }
  }

  private void initSdk(MethodCall call, Result result) {
    Map<String, Object> args = call.arguments();
    String appId = (String) args.get("appId");
    String appKey = (String) args.get("appKey");

    TUSDK.init(context, appId, appKey);
    Log.d(TAG, "SDK initialized successfully");
    result.success(true);
  }

  private void loadInterstitialAd(MethodCall call, Result result) {
    String placementId = call.argument("placementId");

    interstitialAd = new TUInterstitial(activity, placementId);
    interstitialAd.setAdListener(new TUInterstitialListener() {
      @Override
      public void onInterstitialAdLoaded() {
        Log.d(TAG, "Interstitial ad loaded");
        sendEventToDart("onInterstitialAdLoaded", null);
      }

      @Override
      public void onInterstitialAdLoadFail(AdError adError) {
        Log.d(TAG, "Interstitial ad load failed");
        sendEventToDart("onInterstitialAdLoadFail", adError.getFullErrorInfo());
      }

      @Override
      public void onInterstitialAdClicked(TUAdInfo tuAdInfo) {
        Log.d(TAG, "Interstitial ad clicked");
        sendEventToDart("onInterstitialAdClicked", tuAdInfo.getPlacementId());
      }

      @Override
      public void onInterstitialAdShow(TUAdInfo info) {
        Log.d(TAG, "Interstitial ad shown");
        sendEventToDart("onInterstitialAdShow", info.getPlacementId());
      }

      @Override
      public void onInterstitialAdClose(TUAdInfo info) {
        Log.d(TAG, "Interstitial ad closed");
        sendEventToDart("onInterstitialAdClose", info.getPlacementId());
        loadInterstitialAd(call, result);
      }

      @Override
      public void onInterstitialAdVideoStart(TUAdInfo info) {
        Log.d(TAG, "Interstitial ad video started");
        sendEventToDart("onInterstitialAdVideoStart", info.getPlacementId());
      }

      @Override
      public void onInterstitialAdVideoEnd(TUAdInfo info) {
        Log.d(TAG, "Interstitial ad video ended");
        sendEventToDart("onInterstitialAdVideoEnd", info.getPlacementId());
      }

      @Override
      public void onInterstitialAdVideoError(AdError adError) {
        Log.d(TAG, "Interstitial ad video error");
        sendEventToDart("onInterstitialAdVideoError", adError.getFullErrorInfo());
      }
    });

    interstitialAd.load();
    result.success(true);
  }

  private void showInterstitial(Result result) {
    if (interstitialAd != null && interstitialAd.isAdReady()) {
      interstitialAd.show(activity);
      Log.d(TAG, "Interstitial ad shown");
      result.success(true);
    } else {
      result.success(false);
    }
  }

  private void loadSplashAd(MethodCall call, Result result) {
    String placementId = call.argument("placementId");

    splashAd = new TUSplashAd(context, placementId, new TUSplashAdEZListener() {
      @Override
      public void onAdLoaded() {
        Log.d(TAG, "Splash ad loaded");
        sendEventToDart("onSplashAdLoaded", null);

        if (splashAd.isAdReady()) {
          activity.runOnUiThread(() -> {
            FrameLayout splashContainer = new FrameLayout(activity);
            splashContainer.setLayoutParams(new FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT
            ));

            ViewGroup decorView = (ViewGroup) activity.getWindow().getDecorView();
            decorView.addView(splashContainer);
            splashAd.show(activity, splashContainer);
          });
        } else {
          Log.d(TAG, "Splash ad not ready, loading again");
          splashAd.loadAd();
        }
      }

      @Override
      public void onNoAdError(AdError adError) {
        Log.d(TAG, "Splash ad no ad error");
        sendEventToDart("onSplashAdError", adError.getFullErrorInfo());
      }

      @Override
      public void onAdShow(TUAdInfo entity) {
        Log.d(TAG, "Splash ad shown");
        sendEventToDart("onSplashAdShow", entity.getPlacementId());
      }

      @Override
      public void onAdClick(TUAdInfo entity) {
        Log.d(TAG, "Splash ad clicked");
        sendEventToDart("onSplashAdClick", entity.getPlacementId());
      }

      @Override
      public void onAdDismiss(TUAdInfo entity, TUSplashAdExtraInfo extra) {
        Log.d(TAG, "Splash ad dismissed");
        sendEventToDart("onSplashAdDismiss", entity.getPlacementId());
      }
    });

    splashAd.loadAd();
    result.success(true);
  }

  private void loadBannerAd(MethodCall call, Result result) {
    String placementId = call.argument("placementId");

    if (bannerView != null) bannerView.destroy();

    bannerView = new TUBannerView(activity);
    bannerView.setPlacementId(placementId);
    bannerView.setLayoutParams(new FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
    ));

    bannerView.setBannerAdListener(new TUBannerListener() {
      @Override
      public void onBannerLoaded() {
        Log.d(TAG, "Banner ad loaded");
        sendEventToDart("onBannerLoaded", null);
      }

      @Override
      public void onBannerFailed(AdError adError) {
        Log.d(TAG, "Banner ad failed");
        sendEventToDart("onBannerFailed", adError.getFullErrorInfo());
      }

      @Override
      public void onBannerClicked(TUAdInfo tuAdInfo) {
        Log.d(TAG, "Banner ad clicked");
        sendEventToDart("onBannerClicked", tuAdInfo.getPlacementId());
      }

      @Override
      public void onBannerShow(TUAdInfo tuAdInfo) {
        Log.d(TAG, "Banner ad shown");
        sendEventToDart("onBannerShow", tuAdInfo.getPlacementId());
      }

      @Override
      public void onBannerClose(TUAdInfo tuAdInfo) {
        Log.d(TAG, "Banner ad closed");
        sendEventToDart("onBannerClose", tuAdInfo.getPlacementId());
        if (bannerView.getParent() != null) {
          ((ViewGroup) bannerView.getParent()).removeView(bannerView);
        }
      }

      @Override
      public void onBannerAutoRefreshed(TUAdInfo tuAdInfo) {
        Log.d(TAG, "Banner ad auto refreshed");
        sendEventToDart("onBannerAutoRefreshed", tuAdInfo.getPlacementId());
      }

      @Override
      public void onBannerAutoRefreshFail(AdError adError) {
        Log.d(TAG, "Banner ad auto refresh failed");
        sendEventToDart("onBannerAutoRefreshFail", adError.getFullErrorInfo());
      }
    });

    bannerView.loadAd();
    result.success(true);
  }

  private void destroyBannerAd(Result result) {
    if (bannerView != null) {
      bannerView.destroy();
      Log.d(TAG, "Banner ad destroyed");
      bannerView = null;
    }
    result.success(true);
  }

  private void loadNativeAd(MethodCall call, Result result) {
    String placementId = call.argument("placementId");

    tuNative = new TUNative(context, placementId, new TUNativeNetworkListener() {
      @Override
      public void onNativeAdLoaded() {
        Log.d(TAG, "Native ad loaded");
        sendEventToDart("onNativeAdLoaded", null);
      }

      @Override
      public void onNativeAdLoadFail(AdError adError) {
        Log.d(TAG, "Native ad load failed");
        sendEventToDart("onNativeAdLoadFail", adError.getFullErrorInfo());
      }
    });

    tuNative.makeAdRequest();
    result.success(true);
  }

  private void showNativeAd(Result result) {
    nativeAd = tuNative.getNativeAd();
    if (nativeAd != null && nativeAd.isNativeExpress()) {
      Log.d(TAG, "Native ad shown");
      sendEventToDart("onNativeAdReadyToShow", nativeAd.getAdInfo().getPlacementId());
      result.success(true);
    } else {
      result.success(false);
    }
  }

  private void loadRewardedAd(MethodCall call, Result result) {
    String placementId = call.argument("placementId");

    rewardedVideoAd = new TURewardVideoAd(activity, placementId);
    rewardedVideoAd.setAdListener(new TURewardVideoListener() {
      @Override
      public void onRewardedVideoAdLoaded() {
        Log.d(TAG, "Rewarded video ad loaded");
        sendEventToDart("onRewardedVideoAdLoaded", null);
      }

      @Override
      public void onRewardedVideoAdFailed(AdError adError) {
        Log.d(TAG, "Rewarded video ad failed");
        sendEventToDart("onRewardedVideoAdFailed", adError.getFullErrorInfo());
      }

      @Override
      public void onRewardedVideoAdPlayStart(TUAdInfo adInfo) {
        Log.d(TAG, "Rewarded video ad play started");
        sendEventToDart("onRewardedVideoAdPlayStart", adInfo.getPlacementId());
      }

      @Override
      public void onRewardedVideoAdPlayEnd(TUAdInfo adInfo) {
        Log.d(TAG, "Rewarded video ad play ended");
        sendEventToDart("onRewardedVideoAdPlayEnd", adInfo.getPlacementId());
      }

      @Override
      public void onRewardedVideoAdPlayFailed(AdError adError, TUAdInfo adInfo) {
        Log.d(TAG, "Rewarded video ad play failed");
        sendEventToDart("onRewardedVideoAdPlayFailed", adError.getFullErrorInfo());
      }

      @Override
      public void onRewardedVideoAdClosed(TUAdInfo adInfo) {
        Log.d(TAG, "Rewarded video ad closed");
        sendEventToDart("onRewardedVideoAdClosed", adInfo.getPlacementId());
      }

      @Override
      public void onRewardedVideoAdPlayClicked(TUAdInfo tuAdInfo) {
        Log.d(TAG, "Rewarded video ad play clicked");
        sendEventToDart("onRewardedVideoAdPlayClicked", tuAdInfo.getPlacementId());
      }

      @Override
      public void onReward(TUAdInfo tuAdInfo) {
        Log.d(TAG, "Rewarded video ad rewarded");
        sendEventToDart("onReward", tuAdInfo.getPlacementId());
      }
    });

    rewardedVideoAd.load();
    result.success(true);
  }

  private void showRewardedAd(Result result) {
    if (rewardedVideoAd != null && rewardedVideoAd.isAdReady()) {
      rewardedVideoAd.show(activity);
      Log.d(TAG, "Rewarded video ad shown");
      result.success(true);
    } else {
      result.success(false);
    }
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
