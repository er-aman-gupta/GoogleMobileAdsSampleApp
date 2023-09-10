//
//  ViewController.swift
//  Ads
//
//  Created by Aman Gupta on 15/08/23.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    var googleAdLoader: GADAdLoader?
    
    /// A reference to the banner ad.
    private var bannerAdView: GADBannerView?
    /// A reference to native ad view
    private var nativeAdView: NativeAdView?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()

        self.view.backgroundColor = .white
        self.title = "Home"
        let refreshButton = UIBarButtonItem(title: "Refresh",
                                            style: .plain,
                                            target: self,
                                            action: #selector(refreshAd))
        navigationItem.rightBarButtonItem = refreshButton
    }

    @objc private func refreshAd() {
        removeAd()
        loadAd()
    }

    /// This method submits a request to load an ad.
    func loadAd() {
        let adRequest = GAMRequest()
        // Pass any additonal parameters such as cpm, user age, gender, etc for better targeting.
        // This is a [String: String] dictionary.
        adRequest.customTargeting = [:]
        let adLoader = GADAdLoader(adUnitID: Bool.random() ? "/6499/example/native" : "/6499/example/banner",
                                   rootViewController: self,
                                   adTypes: [.gamBanner, .native],
                                   options: nil)
        adLoader.delegate = self
        adLoader.load(adRequest)
        self.googleAdLoader = adLoader
    }

    private func removeAd() {
        self.bannerAdView?.removeFromSuperview()
        self.bannerAdView = nil
        nativeAdView?.removeFromSuperview()
        nativeAdView = nil
    }

    private func setupAdView(withBannerAdView bannerAdView: GADBannerView? = nil,
                             withNativeAd nativeAd: GADNativeAd? = nil) {
        if let bannerAdView {
            self.bannerAdView = bannerAdView
            self.view.addSubview(bannerAdView)
            bannerAdView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bannerAdView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                bannerAdView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                bannerAdView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            ])
        } else if let nativeAd {
            let nativeAdView = NativeAdView()
            nativeAdView.setupView(with: nativeAd)
            self.view.addSubview(nativeAdView)
            nativeAdView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                nativeAdView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                nativeAdView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                nativeAdView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            ])
            self.nativeAdView = nativeAdView
        }
    }
}

/// Delegate for knowing when the banner ad has been loaded.
extension ViewController: GAMBannerAdLoaderDelegate {
    /// A list of banner ad sizes that we expect.
    func validBannerSizes(for adLoader: GADAdLoader) -> [NSValue] {
        let cgSizes: [CGSize] = [
            CGSize(width: 320, height: 50),
            CGSize(width: 320, height: 100),
            CGSize(width: 300, height: 250),
            CGSize(width: 468, height: 60),
        ]
        let sizes = cgSizes.map { cgSize in
            let bannerSize = GADAdSizeFromCGSize(cgSize)
            return NSValueFromGADAdSize(bannerSize)
        }
        return sizes
    }
    
    /// We receive information about failure to load ad here.
    /// If you restricted space on your view hierarchy for banner ad, feel free to remove that as you wont be receiving the ad.
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        debugPrint("Banner Ad Failed to load. Error \(error.localizedDescription)")
    }
    
    /// We receive the banner ad here. The bannerView subclasses from UIView and can be added to your view hierarchy as is.
    func adLoader(_ adLoader: GADAdLoader, didReceive bannerView: GAMBannerView) {
        setupAdView(withBannerAdView: bannerView)
        debugPrint(bannerView.adSize)
        bannerView.delegate = self
    }

}

/// This is optional. If you have a requirement for observing on things like when banner ad has clicked or an impression is recorded then you can conform to this.
extension ViewController: GADBannerViewDelegate {
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        debugPrint("Banner Ad Clicked")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        debugPrint("Banner Ad impression recorded")
    }
}

/// Delegate for knowing when the native ad has been loaded.
extension ViewController: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        setupAdView(withNativeAd: nativeAd)
        nativeAd.delegate = self
    }
}

/// This is optional. If you have a requirement for observing on things like when native ad has clicked or an impression is recorded then you can conform to this.
extension ViewController: GADNativeAdDelegate {
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        debugPrint("Native Ad clicked")
    }

    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        debugPrint("Native Ad impression recorded")
    }
}
