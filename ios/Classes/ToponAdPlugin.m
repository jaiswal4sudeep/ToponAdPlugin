#import "ToponAdPlugin.h"

#import <AnyThinkSDK/AnyThinkSDK.h>

@class ToponAdPlugin;

#pragma mark - Helper Delegate Interfaces

@interface ToponInterstitialDelegate : NSObject <ATInterstitialDelegate, ATAdLoadingDelegate>
@property (nonatomic, weak) ToponAdPlugin *plugin;
@end

@interface ToponRewardedVideoDelegate : NSObject <ATRewardedVideoDelegate, ATAdLoadingDelegate>
@property (nonatomic, weak) ToponAdPlugin *plugin;
@end

@interface ToponBannerDelegate : NSObject <ATBannerDelegate, ATAdLoadingDelegate>
@property (nonatomic, weak) ToponAdPlugin *plugin;
@end

@interface ToponSplashDelegate : NSObject <ATSplashDelegate, ATAdLoadingDelegate>
@property (nonatomic, weak) ToponAdPlugin *plugin;
@end

@interface ToponNativeDelegate : NSObject <ATNativeADDelegate, ATAdLoadingDelegate>
@property (nonatomic, weak) ToponAdPlugin *plugin;
@end

#pragma mark - ToponAdPlugin Interface

@interface ToponAdPlugin ()
@property (nonatomic, strong) FlutterMethodChannel *channel;

@property (nonatomic, copy) FlutterResult pendingInterstitialResult;
@property (nonatomic, copy) FlutterResult pendingRewardedResult;

@property (nonatomic, copy) NSString *currentInterstitialPlacementId;
@property (nonatomic, copy) NSString *currentRewardedPlacementId;
@property (nonatomic, copy) NSString *rewardedS2SUserId;
@property (nonatomic, copy) NSString *rewardedS2SCustomData;

@property (nonatomic, copy) NSString *currentSplashPlacementId;
@property (nonatomic, copy) NSString *currentBannerPlacementId;
@property (nonatomic, copy) NSString *currentBannerPosition;
@property (nonatomic, strong) UIView *bannerContainer;
@property (nonatomic, strong) ATBannerView *currentBannerView;

@property (nonatomic, copy) NSString *currentNativePlacementId;

@property (nonatomic, strong) ToponInterstitialDelegate *interstitialDelegate;
@property (nonatomic, strong) ToponRewardedVideoDelegate *rewardedDelegate;
@property (nonatomic, strong) ToponBannerDelegate *bannerDelegate;
@property (nonatomic, strong) ToponSplashDelegate *splashDelegate;
@property (nonatomic, strong) ToponNativeDelegate *nativeDelegate;
@end

#pragma mark - ToponAdPlugin Implementation

@implementation ToponAdPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"topon_ad_plugin"
                                                                binaryMessenger:[registrar messenger]];
    ToponAdPlugin *instance = [[ToponAdPlugin alloc] init];
    instance.channel = channel;
    
    instance.interstitialDelegate = [[ToponInterstitialDelegate alloc] init];
    instance.interstitialDelegate.plugin = instance;
    
    instance.rewardedDelegate = [[ToponRewardedVideoDelegate alloc] init];
    instance.rewardedDelegate.plugin = instance;
    
    instance.bannerDelegate = [[ToponBannerDelegate alloc] init];
    instance.bannerDelegate.plugin = instance;
    
    instance.splashDelegate = [[ToponSplashDelegate alloc] init];
    instance.splashDelegate.plugin = instance;
    
    instance.nativeDelegate = [[ToponNativeDelegate alloc] init];
    instance.nativeDelegate.plugin = instance;
    
    instance.rewardedS2SCustomData = @"";
    
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *method = call.method;
    
    if ([@"initSdk" isEqualToString:method]) {
        [self initSdk:call result:result];
    } else if ([@"loadInterstitialAd" isEqualToString:method]) {
        [self loadInterstitialAd:call result:result];
    } else if ([@"showInterstitial" isEqualToString:method]) {
        [self showInterstitial:result];
    } else if ([@"loadSplashAd" isEqualToString:method]) {
        [self loadSplashAd:call result:result];
    } else if ([@"loadBannerAd" isEqualToString:method]) {
        [self loadBannerAd:call result:result];
    } else if ([@"removeBannerAd" isEqualToString:method]) {
        [self removeBannerAd:result];
    } else if ([@"loadNativeAd" isEqualToString:method]) {
        [self loadNativeAd:call result:result];
    } else if ([@"getNativeAdInfo" isEqualToString:method]) {
        [self getNativeAdInfo:result];
    } else if ([@"loadRewardedAd" isEqualToString:method]) {
        [self loadRewardedAd:call result:result];
    } else if ([@"setRewardedS2SData" isEqualToString:method]) {
        [self setRewardedS2SData:call result:result];
    } else if ([@"clearRewardedS2SData" isEqualToString:method]) {
        [self clearRewardedS2SData:result];
    } else if ([@"showRewardedAd" isEqualToString:method]) {
        [self showRewardedAd:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)sendEventToDart:(NSString *)method arguments:(id)arguments {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.channel) {
            [self.channel invokeMethod:method arguments:arguments];
            NSLog(@"[ToponAdPlugin] Event sent to Dart: %@ | Arguments: %@", method, arguments);
        }
    });
}

#pragma mark - UI Window & ViewController Helpers

- (UIWindow *)getKeyWindow {
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *w in windowScene.windows) {
                    if (w.isKeyWindow) {
                        return w;
                    }
                }
            }
        }
    }
    window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.firstObject;
    }
    return window;
}

- (UIViewController *)getTopViewController {
    UIWindow *window = [self getKeyWindow];
    UIViewController *topController = window.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

#pragma mark - SDK Initialization

- (void)initSdk:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    NSString *appId = args[@"appId"];
    NSString *appKey = args[@"appKey"];
    
    if (!appId || !appKey || appId.length == 0 || appKey.length == 0) {
        result(@(NO));
        return;
    }
    
    NSError *error = nil;
    BOOL success = [[ATAPI sharedInstance] startWithAppID:appId appKey:appKey error:&error];
    if (success) {
        NSLog(@"[ToponAdPlugin] TopOn SDK initialized successfully for iOS");
    } else {
        NSLog(@"[ToponAdPlugin] TopOn SDK initialization failed: %@", error ? error.localizedDescription : @"Unknown error");
    }
    result(@(success));
}

#pragma mark - Interstitial Ads

- (void)loadInterstitialAd:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *placementId = call.arguments[@"placementId"];
    
    if (self.pendingInterstitialResult != nil) {
        result([FlutterError errorWithCode:@"INTERSTITIAL_PENDING"
                                   message:@"Interstitial ad is already loading or showing"
                                   details:nil]);
        return;
    }
    
    self.pendingInterstitialResult = result;
    self.currentInterstitialPlacementId = placementId;
    
    [[ATAdManager sharedManager] loadADWithPlacementID:placementId extra:@{} delegate:self.interstitialDelegate];
}

- (void)showInterstitial:(FlutterResult)result {
    self.pendingInterstitialResult = nil;
    
    if (self.currentInterstitialPlacementId && [[ATAdManager sharedManager] interstitialReadyForPlacementID:self.currentInterstitialPlacementId]) {
        UIViewController *rootVC = [self getTopViewController];
        [[ATAdManager sharedManager] showInterstitialWithPlacementID:self.currentInterstitialPlacementId
                                                    inViewController:rootVC
                                                            delegate:self.interstitialDelegate];
        result(@(YES));
    } else {
        result(@(NO));
    }
}

#pragma mark - Rewarded Video Ads

- (void)loadRewardedAd:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *placementId = call.arguments[@"placementId"];
    
    if (self.pendingRewardedResult != nil) {
        result([FlutterError errorWithCode:@"REWARDED_PENDING"
                                   message:@"Rewarded ad is already loading or showing"
                                   details:nil]);
        return;
    }
    
    if (![self updateRewardedS2SDataFromCall:call result:result]) {
        return;
    }
    
    self.pendingRewardedResult = result;
    self.currentRewardedPlacementId = placementId;
    
    NSMutableDictionary *extra = [NSMutableDictionary dictionary];
    if (self.rewardedS2SUserId && self.rewardedS2SUserId.length > 0) {
        extra[kATAdLoadingExtraUserIDKey] = self.rewardedS2SUserId;
    }
    if (self.rewardedS2SCustomData && self.rewardedS2SCustomData.length > 0) {
        extra[kATAdLoadingExtraMediaExtraKey] = self.rewardedS2SCustomData;
    }
    
    [[ATAdManager sharedManager] loadADWithPlacementID:placementId extra:extra delegate:self.rewardedDelegate];
}

- (void)setRewardedS2SData:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (self.pendingRewardedResult != nil) {
        result([FlutterError errorWithCode:@"REWARDED_PENDING"
                                   message:@"Cannot change S2S data while a rewarded ad is loading"
                                   details:nil]);
        return;
    }
    
    NSString *userId = call.arguments[@"userId"];
    NSString *customData = call.arguments[@"customData"];
    
    if (!userId || [userId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        result([FlutterError errorWithCode:@"INVALID_USER_ID"
                                   message:@"userId must not be empty"
                                   details:nil]);
        return;
    }
    
    self.rewardedS2SUserId = userId;
    self.rewardedS2SCustomData = customData ?: @"";
    result(@(YES));
}

- (void)clearRewardedS2SData:(FlutterResult)result {
    if (self.pendingRewardedResult != nil) {
        result([FlutterError errorWithCode:@"REWARDED_PENDING"
                                   message:@"Cannot clear S2S data while a rewarded ad is loading"
                                   details:nil]);
        return;
    }
    
    self.rewardedS2SUserId = nil;
    self.rewardedS2SCustomData = @"";
    result(@(YES));
}

- (BOOL)updateRewardedS2SDataFromCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!call.arguments[@"userId"] && !call.arguments[@"customData"]) {
        return YES;
    }
    
    NSString *userId = call.arguments[@"userId"];
    if (!userId || [userId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        result([FlutterError errorWithCode:@"INVALID_USER_ID"
                                   message:@"userId is required when setting rewarded S2S data"
                                   details:nil]);
        return NO;
    }
    
    NSString *customData = call.arguments[@"customData"];
    self.rewardedS2SUserId = userId;
    self.rewardedS2SCustomData = customData ?: @"";
    return YES;
}

- (void)showRewardedAd:(FlutterMethodCall *)call result:(FlutterResult)result {
    self.pendingRewardedResult = nil;
    
    if (self.currentRewardedPlacementId && [[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:self.currentRewardedPlacementId]) {
        UIViewController *rootVC = [self getTopViewController];
        NSString *showCustomData = call.arguments[@"showCustomData"];
        
        if (showCustomData && showCustomData.length > 0) {
            ATShowConfig *config = [[ATShowConfig alloc] initWithScene:@"" showCustomExt:showCustomData];
            if ([[ATAdManager sharedManager] respondsToSelector:@selector(showRewardedVideoWithPlacementID:config:inViewController:delegate:)]) {
                [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:self.currentRewardedPlacementId
                                                                       config:config
                                                             inViewController:rootVC
                                                                     delegate:self.rewardedDelegate];
            } else {
                [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:self.currentRewardedPlacementId
                                                             inViewController:rootVC
                                                                     delegate:self.rewardedDelegate];
            }
        } else {
            [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:self.currentRewardedPlacementId
                                                         inViewController:rootVC
                                                                 delegate:self.rewardedDelegate];
        }
        result(@(YES));
    } else {
        result(@(NO));
    }
}

#pragma mark - Splash Ads

- (void)loadSplashAd:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *placementId = call.arguments[@"placementId"];
    self.currentSplashPlacementId = placementId;
    
    [[ATAdManager sharedManager] loadADWithPlacementID:placementId extra:@{} delegate:self.splashDelegate];
    result(@(YES));
}

- (void)showSplashForPlacementID:(NSString *)placementID {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[ATAdManager sharedManager] splashReadyForPlacementID:placementID]) {
            return;
        }
        
        UIWindow *window = [self getKeyWindow];
        UIViewController *rootVC = [self getTopViewController];
        ATShowConfig *config = [[ATShowConfig alloc] init];
        
        [[ATAdManager sharedManager] showSplashWithPlacementID:placementID
                                                        config:config
                                                        window:window
                                              inViewController:rootVC
                                                         extra:@{}
                                                      delegate:self.splashDelegate];
    });
}

#pragma mark - Banner Ads

- (void)loadBannerAd:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *placementId = call.arguments[@"placementId"];
    NSString *position = call.arguments[@"position"];
    
    self.currentBannerPlacementId = placementId;
    self.currentBannerPosition = position ?: @"bottom";
    
    [[ATAdManager sharedManager] loadADWithPlacementID:placementId extra:@{} delegate:self.bannerDelegate];
    result(@(YES));
}

- (void)displayBannerForPlacementID:(NSString *)placementID {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeBannerViewInternal];
        
        ATBannerView *banner = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:placementID
                                                                                      config:[[ATShowConfig alloc] init]];
        
        if (!banner) {
            NSLog(@"[ToponAdPlugin] Could not retrieve banner view for placement %@", placementID);
            return;
        }
        
        banner.delegate = self.bannerDelegate;
        banner.presentingViewController = [self getTopViewController];
        
        UIWindow *window = [self getKeyWindow];
        UIView *rootView = window.rootViewController.view ?: window;
        
        UIView *container = [[UIView alloc] init];
        container.translatesAutoresizingMaskIntoConstraints = NO;
        container.backgroundColor = [UIColor clearColor];
        
        banner.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:banner];
        [rootView addSubview:container];
        
        self.bannerContainer = container;
        self.currentBannerView = banner;
        
        UILayoutGuide *guide = rootView.safeAreaLayoutGuide;
        BOOL isTop = [@"top" caseInsensitiveCompare:self.currentBannerPosition ?: @"bottom"] == NSOrderedSame;
        
        [NSLayoutConstraint activateConstraints:@[
            [container.leadingAnchor constraintEqualToAnchor:rootView.leadingAnchor],
            [container.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor],
            isTop ? [container.topAnchor constraintEqualToAnchor:guide.topAnchor] : [container.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor],
            [banner.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
            [banner.topAnchor constraintEqualToAnchor:container.topAnchor],
            [banner.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]
        ]];
    });
}

- (void)removeBannerView {
    [self removeBannerViewInternal];
}

- (void)removeBannerViewInternal {
    if (self.bannerContainer) {
        [self.bannerContainer removeFromSuperview];
        self.bannerContainer = nil;
    }
    if (self.currentBannerView) {
        [self.currentBannerView removeFromSuperview];
        self.currentBannerView = nil;
    }
}

- (void)removeBannerAd:(FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeBannerViewInternal];
        result(@(YES));
    });
}

#pragma mark - Native Ads

- (void)loadNativeAd:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *placementId = call.arguments[@"placementId"];
    self.currentNativePlacementId = placementId;
    
    [[ATAdManager sharedManager] loadADWithPlacementID:placementId extra:@{} delegate:self.nativeDelegate];
    result(@(YES));
}

- (void)getNativeAdInfo:(FlutterResult)result {
    if (!self.currentNativePlacementId || self.currentNativePlacementId.length == 0) {
        result([FlutterError errorWithCode:@"NATIVE_AD_NOT_READY"
                                   message:@"Native ad not loaded yet"
                                   details:nil]);
        return;
    }
    
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:self.currentNativePlacementId];
    if (offer) {
        NSDictionary *adInfo = [self buildAdInfoWithOffer:offer];
        result(adInfo);
    } else {
        result([FlutterError errorWithCode:@"NATIVE_AD_NOT_READY"
                                   message:@"Native ad not loaded yet"
                                   details:nil]);
    }
}

- (NSDictionary *)buildAdInfoWithOffer:(ATNativeAdOffer *)offer {
    NSMutableDictionary *adInfo = [NSMutableDictionary dictionary];
    id<ATNativeMaterialProtocol> material = offer.nativeAd;
    
    NSString *(^safeString)(id) = ^NSString *(id val) {
        if (!val || val == [NSNull null]) return @"";
        if ([val isKindOfClass:[NSString class]]) return (NSString *)val;
        return [NSString stringWithFormat:@"%@", val];
    };
    
    NSNumber *(^safeNumber)(id) = ^NSNumber *(id val) {
        if (!val || val == [NSNull null]) return nil;
        if ([val isKindOfClass:[NSNumber class]]) return (NSNumber *)val;
        if ([val isKindOfClass:[NSString class]]) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            return [f numberFromString:(NSString *)val];
        }
        return nil;
    };
    
    NSString *title = material.title ?: @"";
    NSString *desc = material.mainText ?: @"";
    NSString *mainImg = material.imageUrl ?: @"";
    NSString *iconImg = material.iconUrl ?: @"";
    NSString *cta = material.ctaText ?: @"";
    NSNumber *rating = safeNumber(material.rating);
    NSString *source = material.source ?: @"";
    NSString *logoUrl = material.logoUrl ?: @"";
    NSString *videoUrl = material.videoUrl ?: @"";
    NSNumber *price = safeNumber(material.appPrice);
    NSNumber *commentNum = material.commentNum >= 0 ? @(material.commentNum) : nil;
    NSString *advertiser = material.advertiser ?: @"";
    
    adInfo[@"title"] = safeString(title);
    adInfo[@"description"] = safeString(desc);
    adInfo[@"mainImageUrl"] = safeString(mainImg);
    adInfo[@"iconUrl"] = safeString(iconImg);
    adInfo[@"callToAction"] = safeString(cta);
    if (rating) adInfo[@"starRating"] = rating;
    adInfo[@"adFrom"] = safeString(source);
    adInfo[@"adChoiceIconUrl"] = safeString(logoUrl);
    adInfo[@"videoUrl"] = safeString(videoUrl);
    if (price) adInfo[@"appPrice"] = price;
    if (commentNum) adInfo[@"appCommentNum"] = commentNum;
    adInfo[@"advertiserName"] = safeString(advertiser);
    adInfo[@"adType"] = @"";
    adInfo[@"domain"] = @"";
    adInfo[@"warning"] = @"";
    adInfo[@"downloadStatus"] = @(0);
    adInfo[@"downloadProgress"] = @(0);
    
    return adInfo;
}

@end

#pragma mark - Helper Delegate Implementations

@implementation ToponInterstitialDelegate

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    [self.plugin sendEventToDart:@"onInterstitialAdLoaded" arguments:nil];
    if (self.plugin.pendingInterstitialResult) {
        self.plugin.pendingInterstitialResult(@(YES));
        self.plugin.pendingInterstitialResult = nil;
    }
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSString *errorMsg = error ? [error localizedDescription] : @"Interstitial ad load failed";
    [self.plugin sendEventToDart:@"onInterstitialAdLoadFail" arguments:errorMsg];
    if (self.plugin.pendingInterstitialResult) {
        self.plugin.pendingInterstitialResult(@(NO));
        self.plugin.pendingInterstitialResult = nil;
    }
}

- (void)interstitialDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onInterstitialAdShow" arguments:placementID];
}

- (void)interstitialDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onInterstitialAdClicked" arguments:placementID];
}

- (void)interstitialDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onInterstitialAdClose" arguments:placementID];
}

- (void)interstitialDidStartPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onInterstitialAdVideoStart" arguments:placementID];
}

- (void)interstitialDidEndPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onInterstitialAdVideoEnd" arguments:placementID];
}

- (void)interstitialDidFailToPlayVideoForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    NSString *errorMsg = error ? [error localizedDescription] : @"Interstitial video play error";
    [self.plugin sendEventToDart:@"onInterstitialAdVideoError" arguments:errorMsg];
}

@end

@implementation ToponRewardedVideoDelegate

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    [self.plugin sendEventToDart:@"onRewardedVideoAdLoaded" arguments:nil];
    if (self.plugin.pendingRewardedResult) {
        self.plugin.pendingRewardedResult(@(YES));
        self.plugin.pendingRewardedResult = nil;
    }
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSString *errorMsg = error ? [error localizedDescription] : @"Rewarded ad load failed";
    [self.plugin sendEventToDart:@"onRewardedVideoAdFailed" arguments:errorMsg];
    if (self.plugin.pendingRewardedResult) {
        self.plugin.pendingRewardedResult(@(NO));
        self.plugin.pendingRewardedResult = nil;
    }
}

- (void)rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onRewardedVideoAdPlayStart" arguments:placementID];
}

- (void)rewardedVideoDidEndPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onRewardedVideoAdPlayEnd" arguments:placementID];
}

- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    NSString *errorMsg = error ? [error localizedDescription] : @"Rewarded video play failed";
    [self.plugin sendEventToDart:@"onRewardedVideoAdPlayFailed" arguments:errorMsg];
}

- (void)rewardedVideoDidCloseForPlacementID:(NSString *)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onRewardedVideoAdClosed" arguments:placementID];
}

- (void)rewardedVideoDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onRewardedVideoAdPlayClicked" arguments:placementID];
}

- (void)rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onReward" arguments:placementID];
}

- (void)rewardedVideoDidRewardSuccessForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onReward" arguments:placementID];
}

@end

@implementation ToponBannerDelegate

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    [self.plugin sendEventToDart:@"onBannerLoaded" arguments:nil];
    [self.plugin displayBannerForPlacementID:placementID];
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSString *errorMsg = error ? [error localizedDescription] : @"Banner ad load failed";
    [self.plugin sendEventToDart:@"onBannerFailed" arguments:errorMsg];
}

- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onBannerShow" arguments:placementID];
}

- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onBannerClicked" arguments:placementID];
}

- (void)bannerView:(ATBannerView *)bannerView didTapCloseButtonWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onBannerClose" arguments:placementID];
    [self.plugin removeBannerView];
}

- (void)bannerView:(ATBannerView *)bannerView didAutoRefreshWithPlacement:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onBannerAutoRefreshed" arguments:placementID];
}

- (void)bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSString *errorMsg = error ? [error localizedDescription] : @"Banner auto refresh failed";
    [self.plugin sendEventToDart:@"onBannerAutoRefreshFail" arguments:errorMsg];
}

@end

@implementation ToponSplashDelegate

- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {
    if (!isTimeout) {
        [self.plugin sendEventToDart:@"onSplashAdLoaded" arguments:nil];
        [self.plugin showSplashForPlacementID:placementID];
    }
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    [self.plugin sendEventToDart:@"onSplashAdLoaded" arguments:nil];
    [self.plugin showSplashForPlacementID:placementID];
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSString *errorMsg = error ? [error localizedDescription] : @"Splash ad load failed";
    [self.plugin sendEventToDart:@"onSplashAdError" arguments:errorMsg];
}

- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    [self.plugin sendEventToDart:@"onSplashAdError" arguments:@"Splash ad load timeout"];
}

- (void)splashDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onSplashAdShow" arguments:placementID];
}

- (void)splashDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onSplashAdClick" arguments:placementID];
}

- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onSplashAdDismiss" arguments:placementID];
}

@end

@implementation ToponNativeDelegate

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    [self.plugin sendEventToDart:@"onNativeAdLoaded" arguments:nil];
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSString *errorMsg = error ? [error localizedDescription] : @"Native ad load failed";
    [self.plugin sendEventToDart:@"onNativeAdLoadFail" arguments:errorMsg];
}

- (void)didShowNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onAdImpressed" arguments:placementID];
}

- (void)didClickNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onAdClicked" arguments:placementID];
}

- (void)didStartPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onAdVideoStart" arguments:nil];
}

- (void)didEndPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onAdVideoEnd" arguments:nil];
}

- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onAdCloseButtonClick" arguments:placementID];
}

- (void)didTapCloseButtonInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self.plugin sendEventToDart:@"onAdCloseButtonClick" arguments:placementID];
}

@end
