# TopOn rewarded S2S backend setup

The example app sends:

- `userId` before the rewarded ad is loaded;
- JSON `customData` containing `reward_transaction_id`, returned as
  `extra_data`;
- `showCustomData` while showing the ad, returned as `show_custom_ext` inside
  `ilrd`.

## TopOn dashboard

Open the rewarded placement in the TopOn dashboard, enable **Server-side
reward**, and set the callback URL to a public HTTPS GET endpoint. A complete
template is:

```text
https://api.example.com/ads/topon/reward?user_id={user_id}&trans_id={trans_id}&reward_amount={reward_amount}&reward_name={reward_name}&placement_id={placement_id}&extra_data={extra_data}&network_firm_id={network_firm_id}&adsource_id={adsource_id}&scenario_id={scenario_id}&sign={sign}&ilrd={ilrd}
```

Replace only `https://api.example.com/ads/topon/reward` with your endpoint.
Keep the `{...}` placeholders unchanged so TopOn can substitute them.

`ilrd={ilrd}` is optional if you do not use `showCustomData`. It is required
for this example because the example sends a display-time transaction
reference.

## Backend verification

Never store the TopOn secret key in the Flutter app. Keep it on the backend and
calculate lowercase MD5 using this exact field order.

Without `ilrd`:

```text
MD5("trans_id=" + trans_id
  + "&placement_id=" + placement_id
  + "&adsource_id=" + adsource_id
  + "&reward_amount=" + reward_amount
  + "&reward_name=" + reward_name
  + "&sec_key=" + TOPON_SECRET_KEY)
```

When the callback URL includes `ilrd`:

```text
MD5("trans_id=" + trans_id
  + "&placement_id=" + placement_id
  + "&adsource_id=" + adsource_id
  + "&reward_amount=" + reward_amount
  + "&reward_name=" + reward_name
  + "&sec_key=" + TOPON_SECRET_KEY
  + "&ilrd=" + ilrd)
```

Compare the calculated value with the received `sign` before processing any
reward.

## Reward-processing checklist

1. Validate `sign` and reject invalid callbacks.
2. Validate `placement_id`, reward name, and reward amount against server-side
   configuration rather than trusting client data.
3. Use TopOn's `trans_id` as a unique database key. If it has already been
   processed, return success without crediting the user twice.
4. Find the backend account using `user_id`.
5. Treat `extra_data` and `ilrd/show_custom_ext` as untrusted metadata.
6. Credit the reward and commit the `trans_id` in one database transaction.
7. Respond quickly with:
   - HTTP `200` for success, including an already-processed `trans_id`;
   - HTTP `601` when signature verification fails;
   - HTTP `602` for another permanent processing failure.

TopOn documents a two-second callback timeout and retries timed-out callbacks,
so the endpoint should avoid slow work before returning its status.
