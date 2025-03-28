package com.adzvortex.topon_ad_plugin;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;

import com.anythink.core.api.ATAdConst;
import com.anythink.core.api.ATAdInfo;
import com.anythink.core.api.ATSDK;
import com.anythink.core.api.AdError;
import com.anythink.core.basead.adx.api.ATAdxBidFloorInfo;
import com.anythink.interstitial.api.ATInterstitial;
import com.anythink.interstitial.api.ATInterstitialListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class ToponAdPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Context context;
  private Activity activity;
  private ATInterstitial mInterstitialAd;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "topon_ad_plugin");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "initializeSdk":
        handleInitializeSdk(call, result);
        break;

      case "loadAd":
        handleLoadAd(call, result);
        break;

      case "showAd":
        handleShowAd(result);
        break;

      default:
        result.notImplemented();
        break;
    }
  }

  private void handleInitializeSdk(MethodCall call, Result result) {
    Map<String, Object> args = call.arguments();
    String appId = (String) args.get("appId");
    String appKey = (String) args.get("appKey");

    ATSDK.init(context, appId, appKey);
    Log.d("ToponAdPlugin", "SDK initialized with appId: " + appId + " and appKey: " + appKey);
    result.success(true);
  }

  private void handleLoadAd(MethodCall call, Result result) {
    Map<String, Object> args = call.arguments();
    String placementId = (String) args.get("placementId");

    mInterstitialAd = new ATInterstitial(activity, placementId);

    mInterstitialAd.setAdListener(new ATInterstitialListener() {
      @Override
      public void onInterstitialAdLoaded() {
        Log.d("ToponAdPlugin", "Interstitial Ad Loaded");
      }

      @Override
      public void onInterstitialAdLoadFail(AdError adError) {
        Log.e("ToponAdPlugin", "Ad Load Failed: " + adError.getFullErrorInfo());
      }

      @Override
      public void onInterstitialAdClicked(ATAdInfo atAdInfo) {
        Log.d("ToponAdPlugin", "Interstitial Ad Clicked");
      }

      @Override
      public void onInterstitialAdShow(ATAdInfo atAdInfo) {
        Log.d("ToponAdPlugin", "Interstitial Ad Shown");
        mInterstitialAd.load();
      }

      @Override
      public void onInterstitialAdClose(ATAdInfo atAdInfo) {
        Log.d("ToponAdPlugin", "Interstitial Ad Closed");
      }

      @Override
      public void onInterstitialAdVideoStart(ATAdInfo atAdInfo) {
        Log.d("ToponAdPlugin", "Video Started");
      }

      @Override
      public void onInterstitialAdVideoEnd(ATAdInfo atAdInfo) {
        Log.d("ToponAdPlugin", "Video Ended");
      }

      @Override
      public void onInterstitialAdVideoError(AdError adError) {
        Log.e("ToponAdPlugin", "Video Error: " + adError.getFullErrorInfo());
      }
    });

    mInterstitialAd.load();
    Log.d("ToponAdPlugin", "Loading interstitial ad for placementId: " + placementId);
    result.success(true);
  }

  private void handleShowAd(Result result) {
    if (mInterstitialAd != null && mInterstitialAd.isAdReady()) {
      Log.d("ToponAdPlugin", "Ad is ready. Showing now.");
      mInterstitialAd.show(activity);
      result.success(true);
    } else {
      Log.d("ToponAdPlugin", "Ad not ready. Reloading...");
      if (mInterstitialAd != null) {
        mInterstitialAd.load();
      }
      result.success(false);
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
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
}
