package com.sudeep.topon_ad_plugin;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
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
  private FrameLayout bannerContainer;
  private TUNative tuNative;
  private NativeAd nativeAd;
  private TURewardVideoAd rewardedVideoAd;

  private Result pendingInterstitialResult;
  private Result pendingRewardedResult;

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
      case "removeBannerAd":
        removeBannerAd(result);
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
      Log.d(TAG, "Event sent to Dart: " + method);
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

    if (pendingInterstitialResult != null) {
      result.error("INTERSTITIAL_PENDING", "Interstitial ad is already loading or showing", null);
      return;
    }

    pendingInterstitialResult = result;

    interstitialAd = new TUInterstitial(activity, placementId);
    interstitialAd.setAdListener(new TUInterstitialListener() {
      @Override
      public void onInterstitialAdLoaded() {
        Log.d(TAG, "Interstitial ad loaded");
        sendEventToDart("onInterstitialAdLoaded", null);
        if (pendingInterstitialResult != null) {
          pendingInterstitialResult.success(true);
          pendingInterstitialResult = null;
        }
      }

      @Override
      public void onInterstitialAdLoadFail(AdError adError) {
        Log.d(TAG, "Interstitial ad load failed");
        sendEventToDart("onInterstitialAdLoadFail", adError.getFullErrorInfo());
        if (pendingInterstitialResult != null) {
          pendingInterstitialResult.success(false);
          pendingInterstitialResult = null;
        }
      }

      @Override
      public void onInterstitialAdClicked(TUAdInfo info) {
        sendEventToDart("onInterstitialAdClicked", info.getPlacementId());
      }

      @Override
      public void onInterstitialAdShow(TUAdInfo info) {
        sendEventToDart("onInterstitialAdShow", info.getPlacementId());
      }

      @Override
      public void onInterstitialAdClose(TUAdInfo info) {
        sendEventToDart("onInterstitialAdClose", info.getPlacementId());
      }

      @Override
      public void onInterstitialAdVideoStart(TUAdInfo info) {
        sendEventToDart("onInterstitialAdVideoStart", info.getPlacementId());
      }

      @Override
      public void onInterstitialAdVideoEnd(TUAdInfo info) {
        sendEventToDart("onInterstitialAdVideoEnd", info.getPlacementId());
      }

      @Override
      public void onInterstitialAdVideoError(AdError adError) {
        sendEventToDart("onInterstitialAdVideoError", adError.getFullErrorInfo());
      }
    });

    interstitialAd.load();
  }

  private void showInterstitial(Result result) {
    pendingInterstitialResult = null;
    if (interstitialAd != null && interstitialAd.isAdReady()) {
      interstitialAd.show(activity);
      result.success(true);
    } else {
      result.success(false);
    }
  }

  private void loadRewardedAd(MethodCall call, Result result) {
    String placementId = call.argument("placementId");

    if (pendingRewardedResult != null) {
      result.error("REWARDED_PENDING", "Rewarded ad is already loading or showing", null);
      return;
    }

    pendingRewardedResult = result;

    rewardedVideoAd = new TURewardVideoAd(activity, placementId);
    rewardedVideoAd.setAdListener(new TURewardVideoListener() {
      @Override
      public void onRewardedVideoAdLoaded() {
        sendEventToDart("onRewardedVideoAdLoaded", null);
        if (pendingRewardedResult != null) {
          pendingRewardedResult.success(true);
          pendingRewardedResult = null;
        }
      }

      @Override
      public void onRewardedVideoAdFailed(AdError adError) {
        sendEventToDart("onRewardedVideoAdFailed", adError.getFullErrorInfo());
        if (pendingRewardedResult != null) {
          pendingRewardedResult.success(false);
          pendingRewardedResult = null;
        }
      }

      @Override
      public void onRewardedVideoAdPlayStart(TUAdInfo adInfo) {
        sendEventToDart("onRewardedVideoAdPlayStart", adInfo.getPlacementId());
      }

      @Override
      public void onRewardedVideoAdPlayEnd(TUAdInfo adInfo) {
        sendEventToDart("onRewardedVideoAdPlayEnd", adInfo.getPlacementId());
      }

      @Override
      public void onRewardedVideoAdPlayFailed(AdError adError, TUAdInfo adInfo) {
        sendEventToDart("onRewardedVideoAdPlayFailed", adError.getFullErrorInfo());
      }

      @Override
      public void onRewardedVideoAdClosed(TUAdInfo adInfo) {
        sendEventToDart("onRewardedVideoAdClosed", adInfo.getPlacementId());
      }

      @Override
      public void onRewardedVideoAdPlayClicked(TUAdInfo adInfo) {
        sendEventToDart("onRewardedVideoAdPlayClicked", adInfo.getPlacementId());
      }

      @Override
      public void onReward(TUAdInfo adInfo) {
        sendEventToDart("onReward", adInfo.getPlacementId());
      }
    });

    rewardedVideoAd.load();
  }

  private void showRewardedAd(Result result) {
    pendingRewardedResult = null;
    if (rewardedVideoAd != null && rewardedVideoAd.isAdReady()) {
      rewardedVideoAd.show(activity);
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
    String position = call.argument("position");

    if(bannerView == null){
      bannerView = new TUBannerView(activity);
      bannerView.setPlacementId(placementId);

      int width = activity.getResources().getDisplayMetrics().widthPixels;
      int height = ViewGroup.LayoutParams.WRAP_CONTENT;
      bannerView.setLayoutParams(new FrameLayout.LayoutParams(width, height));

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
          if (bannerContainer != null) {
            bannerContainer.setVisibility(View.GONE);
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
    }

    activity.runOnUiThread(()-> {
      ViewGroup decorView = (ViewGroup) activity.getWindow().getDecorView();

      if (bannerContainer != null) {
        decorView.removeView(bannerContainer);
      }

      if(bannerView.getParent() != null){
        ((ViewGroup) bannerView.getParent()).removeView(bannerView);
      }

      bannerContainer = new FrameLayout(activity);
      FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
              ViewGroup.LayoutParams.MATCH_PARENT,
              ViewGroup.LayoutParams.WRAP_CONTENT
      );

      if("top".equalsIgnoreCase(position)){
        params.gravity = Gravity.TOP;
      }else{
        params.gravity = Gravity.BOTTOM;
      }

      bannerContainer.setLayoutParams(params);
      bannerContainer.addView(bannerView);
      decorView.addView(bannerContainer);
      bannerContainer.setVisibility(View.VISIBLE);
    });

    bannerView.loadAd();
    result.success(true);
  }

  private void removeBannerAd(Result result) {
    activity.runOnUiThread(() -> {
      if (bannerContainer != null) {
        ViewGroup decorView = (ViewGroup) activity.getWindow().getDecorView();
        decorView.removeView(bannerContainer);
        bannerContainer = null;
        Log.d(TAG, "Banner ad removed");
      }

      if (bannerView != null) {
        if (bannerView.getParent() != null) {
          ((ViewGroup) bannerView.getParent()).removeView(bannerView);
        }
        bannerView = null;
      }

      result.success(true);
    });
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
