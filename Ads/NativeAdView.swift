//
//  NativeAdView.swift
//  Ads
//
//  Created by Aman Gupta on 09/09/23.
//

import GoogleMobileAds
import UIKit

class NativeAdView: GADNativeAdView {

    private let parentStackView = UIStackView()
    private let imageHeadlineStackView = UIStackView()
    private let headlineLabelView = UILabel()
    private let descriptionLabel = UILabel()
    private let advertiserImageView = UIImageView()
    private let adMediaView = GADMediaView()
    private let ctaButtonView = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .white
        self.addSubview(parentStackView)
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            parentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            parentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            parentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
        parentStackView.axis = .vertical
        parentStackView.spacing = 16
        parentStackView.addArrangedSubview(imageHeadlineStackView)
        parentStackView.addArrangedSubview(descriptionLabel)
        parentStackView.addArrangedSubview(adMediaView)
        parentStackView.addArrangedSubview(ctaButtonView)

        imageHeadlineStackView.axis = .horizontal
        imageHeadlineStackView.spacing = 16
        imageHeadlineStackView.addArrangedSubview(advertiserImageView)
        imageHeadlineStackView.addArrangedSubview(headlineLabelView)

        advertiserImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            advertiserImageView.heightAnchor.constraint(equalToConstant: 44),
            advertiserImageView.widthAnchor.constraint(equalToConstant: 44)
        ])

        ctaButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ctaButtonView.heightAnchor.constraint(equalToConstant: 48)
        ])

        headlineLabelView.font = UIFont.preferredFont(forTextStyle: .headline)
        headlineLabelView.textColor = .black

        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0

        advertiserImageView.layer.cornerRadius = 22
        advertiserImageView.clipsToBounds = true

        ctaButtonView.backgroundColor = .blue
        ctaButtonView.setTitleColor(.white, for: .normal)
        ctaButtonView.isUserInteractionEnabled = false

        headlineView = headlineLabelView
        bodyView = descriptionLabel
        iconView = advertiserImageView
        mediaView = adMediaView
        callToActionView = ctaButtonView
    }

    func setupView(with nativeAd: GADNativeAd) {
        self.nativeAd = nativeAd
        headlineLabelView.text = nativeAd.headline
        descriptionLabel.text = nativeAd.body
        adMediaView.mediaContent = nativeAd.mediaContent
        ctaButtonView.setTitle(nativeAd.callToAction, for: .normal)
        advertiserImageView.image = nativeAd.icon?.image

        let width = UIScreen.main.bounds.width
        var height = CGFloat.zero
        if nativeAd.mediaContent.aspectRatio != 0 {
            height = width / nativeAd.mediaContent.aspectRatio
        }
        adMediaView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adMediaView.heightAnchor.constraint(equalToConstant: height),
        ])

    }
}
