//
//  OrderViewController.swift
//  Buber
//
//  Created by Alexey Salangin on 11/16/19.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit
import SnapKit

final class OrderViewController: UIViewController {
    private let contentStackView = UIStackView()

    private let infoView = UIView()
    private let separatorView: UIView
    private let paymentInfoView = PaymentView()
    private let orderButton: UIButton

    init() {
        self.orderButton = Self.makeOrderButton()
        self.separatorView = Self.makeSeparatorView()

        super.init(nibName: nil, bundle: nil)

        self.view.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(20)
            make.left.equalTo(self.view.snp.left).offset(24)
            make.right.equalTo(self.view.snp.right).offset(-24)
            make.height.equalTo(400 - 20 - 20)
        }

        self.setupSubviews()
    }

    private func setupSubviews() {
        self.contentStackView.axis = .vertical
        self.contentStackView.spacing = 24

        self.contentStackView.addArrangedSubview(self.infoView)
        self.contentStackView.addArrangedSubview(self.separatorView)
        self.contentStackView.addArrangedSubview(self.paymentInfoView)
        self.contentStackView.addArrangedSubview(self.orderButton)
    }

    private static func makeSeparatorView() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return separator
    }

    private static func makeOrderButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .app
        button.layer.cornerRadius = 10
        button.setTitle("Order bus", for: .normal)
        button.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
        return button
    }
}
