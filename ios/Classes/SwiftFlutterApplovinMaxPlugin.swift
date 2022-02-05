import Flutter
import UIKit
import AppLovinSDK

var globalMethodChannel: FlutterMethodChannel?
var bannerMethodChannel: FlutterMethodChannel?

public class SwiftFlutterApplovinMaxPlugin:  NSObject, FlutterPlugin {
    private var rewardMax = ALMAXReward();
    private var interMax = ALMAXInterstitial();

    public static func register(with registrar: FlutterPluginRegistrar) {
        globalMethodChannel = FlutterMethodChannel(name: "flutter_applovin_max", binaryMessenger: registrar.messenger())
        bannerMethodChannel = FlutterMethodChannel(name: "flutter_applovin_max_banner", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterApplovinMaxPlugin()
        registrar.addMethodCallDelegate(instance, channel: globalMethodChannel!)
        registrar.register(
            ALMAXBannerAdFactory(_registrar: registrar),
                    withId: "/Banner"
                )
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "InitSdk":
            let args = call.arguments as? Dictionary<String, Any>
            if let userId = args?["UserId"] as? String {
                    ALSdk.shared()!.userIdentifier = userId
            }
            
            ALSdk.shared()!.mediationProvider = ALMediationProviderMAX
            ALSdk.shared()!.initializeSdk(completionHandler: { configuration in
                // AppLovin SDK is initialized, start loading ads now or later if ad gate is reached
                if let rewardId = args?["RewardId"] as? String {
                    self.rewardMax.initRewardedApplovin(rewardId)
                }
                if let interId = args?["InterId"] as? String {
                    self.interMax.initInterApplovin(interId)
                }
                result(true)
            })
        case "ShowDebugger":
            ALSdk.shared()!.showMediationDebugger()
            result(true)
        /*Reward*/
        case "InitRewardAd":
            rewardMax.initRewardedApplovin(call)
            result(true)
        case "ShowRewardVideo":
            if rewardMax.Ad?.isReady ?? false {
                rewardMax.Ad?.show()
                result(true)
            }
        case "IsRewardLoaded":
            result(rewardMax.Ad?.isReady ?? false)
        /*Inter*/
        case "InitInterAd":
            interMax.initInterApplovin(call)
            result(true)
        case "ShowInterVideo":
            if interMax.Ad?.isReady ?? false {
                interMax.Ad?.show()
                result(true)
            }
        case "IsInterLoaded":
            result(interMax.Ad?.isReady ?? false)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
