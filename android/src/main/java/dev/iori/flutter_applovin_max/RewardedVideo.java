package dev.iori.flutter_applovin_max;

import com.applovin.mediation.MaxAd;
import com.applovin.mediation.MaxAdRevenueListener;
import com.applovin.mediation.MaxError;
import com.applovin.mediation.MaxReward;
import com.applovin.mediation.MaxRewardedAdListener;
import com.applovin.mediation.ads.MaxRewardedAd;


import io.flutter.Log;

public class RewardedVideo implements MaxRewardedAdListener, MaxAdRevenueListener {
    private MaxRewardedAd RewardedAd;
    private int           retryAttempt;

    public void Init(String unitId) {
        RewardedAd = MaxRewardedAd.getInstance(unitId, FlutterApplovinMaxPlugin.getInstance().activity );
        RewardedAd.setListener( this );
        RewardedAd.loadAd();
    }

    public void Show(String placementId, String custom) {
        try {
            if (RewardedAd != null && RewardedAd.isReady() && FlutterApplovinMaxPlugin.getInstance().activity != null){
                if(custom != null){
                    RewardedAd.showAd(placementId, custom);
                }else{
                    RewardedAd.showAd(placementId);
                }
            }
                
        } catch (Exception e) {
            Log.e("AppLovin", e.toString());
        }
    }

    public boolean IsLoaded() {
        return RewardedAd.isReady();
    }

    @Override
    public void onAdLoaded(MaxAd ad) {
        retryAttempt = 0;
        FlutterApplovinMaxPlugin.getInstance().Callback("AdLoaded");

    }

    @Override
    public void onAdDisplayed(MaxAd ad) {
        FlutterApplovinMaxPlugin.getInstance().Callback("AdDisplayed");

    }

    @Override
    public void onAdHidden(MaxAd ad) {
        FlutterApplovinMaxPlugin.getInstance().Callback("AdHidden");
        RewardedAd.loadAd();
    }

    @Override
    public void onAdClicked(MaxAd ad) {
        FlutterApplovinMaxPlugin.getInstance().Callback("AdClicked");
    }

    @Override
    public void onAdLoadFailed(String adUnitId, MaxError error) {
        FlutterApplovinMaxPlugin.getInstance().Callback("AdLoadFailed");
    }

    @Override
    public void onAdDisplayFailed(MaxAd ad, MaxError error) {
        FlutterApplovinMaxPlugin.getInstance().Callback("AdDisplayFailed");
    }

    @Override
    public void onRewardedVideoStarted(MaxAd ad) {
        FlutterApplovinMaxPlugin.getInstance().Callback("RewardedVideoStarted");

    }

    @Override
    public void onRewardedVideoCompleted(MaxAd ad) {
        FlutterApplovinMaxPlugin.getInstance().Callback("RewardedVideoCompleted");

    }

    @Override
    public void onAdRevenuePaid(MaxAd ad) {
        FlutterApplovinMaxPlugin.getInstance().Callback("AdRevenuePaid");
    }

    @Override
    public void onUserRewarded(MaxAd ad, MaxReward reward) {
        Log.d("onUserRewarded","reward" + reward);
        FlutterApplovinMaxPlugin.getInstance().Callback("UserRewarded");

    }
}
