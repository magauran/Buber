//
//  ConfirmViewController.swift
//  Buber
//
//  Created by Alexey Salangin on 11/16/19.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit
import SnapKit

final class ConfirmViewController: UIViewController {
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        blurView.alpha = 0.4
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.shadowRadius = 10
        self.contentView.layer.shadowOpacity = 0.5
        self.contentView.layer.shadowColor = UIColor.gray.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 4)

        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            let topBottomInset = self.view.frame.height * 0.24
            let leftRightInset = self.view.frame.width * 0.1
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: topBottomInset, left: leftRightInset, bottom: topBottomInset, right: leftRightInset)
            )
        }

        self.setupSubviews()
    }

    private func setupSubviews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 52, left: 32, bottom: 60, right: 32))
        }

        let title = UILabel()
        title.textAlignment = .center
        title.text = "Your bus is on the way!"
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        let imageView = UIImageView()
        imageView.image = UIImage(named: "busPhoto")
        imageView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        imageView.contentMode = .scaleAspectFit

        let description = UILabel()
        description.text = "Bus no. 550 is about 4 minutes away to Aalto University station to pick you up. Have a fun ride!"
        description.numberOfLines = 0
        description.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        let button = UIButton()
        button.setTitle("OK", for: .normal)
        let image = UIImage.imageWith(color: .app)
        button.setBackgroundImage(image, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.snp.makeConstraints { make in
            make.height.equalTo(46)
        }

        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(description)
        stackView.addArrangedSubview(button)
    }
}
