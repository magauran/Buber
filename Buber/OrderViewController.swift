//
//  OrderViewController.swift
//  Buber
//
//  Created by Alexey Salangin on 11/16/19.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit
import SnapKit

protocol OrderViewControllerDelegate: AnyObject {
    func orderViewControllerDidTapOrderButton(_ vc: OrderViewController)
}

final class OrderViewController: UIViewController {
    weak var delegate: OrderViewControllerDelegate?

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
            make.top.equalTo(self.view.snp.top).offset(55)
            make.left.equalTo(self.view.snp.left).offset(24)
            make.right.equalTo(self.view.snp.right).offset(-24)
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

        self.setupInfoView()

        self.orderButton.addTarget(self, action: #selector(self.didTapOrderButton), for: .touchUpInside)
    }

    private func setupInfoView() {
        let busInfoView = BusInfoView()
        let routeInfoView = RouteInfoView()

        self.infoView.addSubview(busInfoView)
        self.infoView.addSubview(routeInfoView)

        busInfoView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }

        routeInfoView.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(busInfoView.snp.right)
            make.width.equalTo(busInfoView)
        }
    }

    @objc
    private func didTapOrderButton() {
        self.delegate?.orderViewControllerDidTapOrderButton(self)
    }

    private static func makeSeparatorView() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return separator
    }

    private static func makeOrderButton() -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage.imageWith(color: .app), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Order bus", for: .normal)
        button.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
        return button
    }
}
