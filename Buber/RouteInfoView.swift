//
//  RouteInfoView.swift
//  Buber
//
//  Created by Alexey Salangin on 11/16/19.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit

final class RouteInfoView: UIView {
    private enum Layout {
        static let textLeftInset: CGFloat = 30
        static let textRightInset: CGFloat = 0
        static let titleBottomInset: CGFloat = 8
        static let sectionHeight: CGFloat = 36
    }

    private let yourLocationLabel = UILabel()
    private let walkLabel = UILabel()
    private let sourceLabel = UILabel()
    private let busLabel = UILabel()
    private let stopsLabel = UILabel()
    private let destionationLabel = UILabel()

    init() {
        super.init(frame: .zero)

        self.setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()


    }

    private func setupSubviews() {
        self.addSubview(self.yourLocationLabel)
        self.addSubview(self.walkLabel)
        self.addSubview(self.sourceLabel)
        self.addSubview(self.busLabel)
        self.addSubview(self.stopsLabel)
        self.addSubview(self.destionationLabel)

        self.yourLocationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Layout.textLeftInset)
            make.right.equalToSuperview().offset(-Layout.textRightInset)
        }

        self.walkLabel.snp.makeConstraints { make in
            make.top.equalTo(self.yourLocationLabel.snp.bottom).offset(Layout.titleBottomInset)
            make.left.equalToSuperview().offset(Layout.textLeftInset)
            make.right.equalToSuperview().offset(-Layout.textRightInset)
        }

        self.sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.yourLocationLabel.snp.bottom).offset(Layout.sectionHeight)
            make.left.equalToSuperview().offset(Layout.textLeftInset)
            make.right.equalToSuperview().offset(-Layout.textRightInset)
        }

        self.busLabel.snp.makeConstraints { make in
            make.top.equalTo(self.sourceLabel.snp.bottom).offset(Layout.titleBottomInset)
            make.left.equalToSuperview().offset(Layout.textLeftInset)
            make.right.equalToSuperview().offset(-Layout.textRightInset)
        }

        self.stopsLabel.snp.makeConstraints { make in
            make.top.equalTo(self.sourceLabel.snp.bottom).offset(Layout.sectionHeight)
            make.left.equalToSuperview().offset(Layout.textLeftInset)
            make.right.equalToSuperview().offset(-Layout.textRightInset)
        }

        self.destionationLabel.snp.makeConstraints { make in
            make.top.equalTo(self.stopsLabel.snp.bottom).offset(Layout.sectionHeight)
            make.left.equalToSuperview().offset(Layout.textLeftInset)
            make.right.equalToSuperview().offset(-Layout.textRightInset)
        }

        self.setupLabelsText()
    }

    private func setupLabelsText() {
        self.yourLocationLabel.attributedText = Self.makeTitleAttributedText(value: "Your location", lineHeight: 19)
        self.walkLabel.attributedText = Self.makeDescriptionAttributedText(value: "Walk for 250m, about 2 mins")
        self.sourceLabel.attributedText = Self.makeTitleAttributedText(value: "Aalto University", lineHeight: 19)
        self.busLabel.attributedText = Self.makeDescriptionAttributedText(value: "Bus 550 Itäkeskus")
        self.stopsLabel.attributedText = Self.makeTitleAttributedText(value: "4 stops (12 mins)", lineHeight: 19)
        self.destionationLabel.attributedText = Self.makeTitleAttributedText(value: "Itäkeskus", lineHeight: 18)

        [
            self.yourLocationLabel, self.walkLabel, self.sourceLabel,
            self.busLabel, self.stopsLabel, self.destionationLabel
        ].forEach { label in
            label.numberOfLines = 0
        }
    }

    private static func makeTitleAttributedText(value: String, lineHeight: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let attributedText = NSAttributedString(
            string: value,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.app
            ]
        )

        return attributedText
    }

    private static func makeDescriptionAttributedText(value: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 10
        paragraphStyle.maximumLineHeight = 10

        let attributedText = NSAttributedString(
            string: value,
            attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.blackText
            ]
        )

        return attributedText
    }
}
