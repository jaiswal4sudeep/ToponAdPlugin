import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:topon_ad_plugin/topon_ad_plugin.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('topon_ad_plugin');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return true;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('passes S2S data when loading a rewarded ad', () async {
    final result = await ToponAdPlugin.loadRewardedAd(
      placementId: 'rewarded-placement',
      userId: 'user-42',
      customData: 'reward-transaction-7',
    );

    expect(result, isTrue);
    expect(calls.single.method, 'loadRewardedAd');
    expect(calls.single.arguments, {
      'placementId': 'rewarded-placement',
      'userId': 'user-42',
      'customData': 'reward-transaction-7',
    });
  });

  test('sets, shows with custom data, and clears S2S data', () async {
    expect(
      await ToponAdPlugin.setRewardedS2SData(
        userId: 'user-42',
        customData: 'load-data',
      ),
      isTrue,
    );
    expect(
      await ToponAdPlugin.showRewardedAd(showCustomData: 'show-data'),
      isTrue,
    );
    expect(await ToponAdPlugin.clearRewardedS2SData(), isTrue);

    expect(calls[0].method, 'setRewardedS2SData');
    expect(calls[0].arguments, {
      'userId': 'user-42',
      'customData': 'load-data',
    });
    expect(calls[1].method, 'showRewardedAd');
    expect(calls[1].arguments, {'showCustomData': 'show-data'});
    expect(calls[2].method, 'clearRewardedS2SData');
  });

  test('rejects an empty S2S user id before invoking native code', () async {
    final result = await ToponAdPlugin.setRewardedS2SData(userId: '  ');

    expect(result, isFalse);
    expect(calls, isEmpty);
  });
}
