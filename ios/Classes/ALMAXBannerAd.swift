//
//  ALMAXBannerAd.swift
//  flutter_applovin_max
//
//  Created by Edward Chow on 26/1/2022.
//

import Foundation
import AppLovinSDK
import Flutter

class ALMAXBannerAdFactory: NSObject, FlutterPlatformViewFactory{
    let registrar: FlutterPluginRegistrar
    init(_registrar: FlutterPluginRegistrar) {
            registrar = _registrar
            super.init()
        }
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
            
            return FlutterStandardMessageCodec.sharedInstance()
        }
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
            
        return ALMAXBannerAdView(_frame: frame, _viewId: viewId, _params: args as? Dictionary<String, Any> ?? nil, _registrar: registrar)
        }
}

class ALMAXBannerAdView: NSObject, FlutterPlatformView,MAAdViewAdDelegate{
    private let frame: CGRect
    private let viewId: Int64
    private let registrar: FlutterPluginRegistrar
    private let params: [String: Any]
    var mainView: UIView!
    var adView: MAAdView!
    func view() -> UIView {
        return adView
    }
    init(_frame: CGRect,
             _viewId: Int64,
             _params: [String: Any]?,
             _registrar: FlutterPluginRegistrar) {
            
            frame = _frame
            viewId = _viewId
            registrar = _registrar
            params = _params!
        super.init()
//        initView()
        initMaxView()
           
        }
    func initView(){
        self.mainView = UIView(frame: self.frame)
        self.mainView.backgroundColor = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 0)
    }
    func initMaxView(){
        let height: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 50
        let width: CGFloat = UIScreen.main.bounds.width
        let unitId: String = self.params["UnitId"] as! String
        adView = MAAdView(adUnitIdentifier: unitId)
        adView.delegate = self
        adView.frame = CGRect(x: self.frame.midX, y: self.frame.midY, width: width, height: height)
        adView.backgroundColor = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 0)
        
        adView.loadAd()
        
    }

    func didExpand(_ ad: MAAd) {
    }
    
    func didCollapse(_ ad: MAAd) {
    }
    
    func didLoad(_ ad: MAAd) {
        bannerMethodChannel?.invokeMethod("AdLoaded", arguments: nil)
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        bannerMethodChannel?.invokeMethod("AdFailedToDisplay", arguments: nil)
    }
    
    func didDisplay(_ ad: MAAd) {
        bannerMethodChannel?.invokeMethod("AdDisplayed", arguments: nil)
    }
    
    func didHide(_ ad: MAAd) {
        bannerMethodChannel?.invokeMethod("AdHidden", arguments: nil)
    }
    
    func didClick(_ ad: MAAd) {
        bannerMethodChannel?.invokeMethod("AdClicked", arguments: nil)
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        adView?.loadAd()
    }
    
    
}
