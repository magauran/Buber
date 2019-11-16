//
//  BusInfoView.swift
//  Buber
//
//  Created by Alexey Salangin on 11/16/19.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit

final class BusInfoView: UIView {
    private let contentStackView = UIStackView()

    init() {
        super.init(frame: .zero)
        self.setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        self.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.contentStackView.axis = .vertical
        self.contentStackView.spacing = 8

        let numberLabel = UILabel()
        numberLabel.font = UIFont.boldSystemFont(ofSize: 21)
        numberLabel.text = "NO. 550"

        let modelLabel = UILabel()
        modelLabel.font = UIFont.boldSystemFont(ofSize: 16)
        modelLabel.text = "Itäkeskus"

        let busView = UIStackView()
        busView.axis = .horizontal
        busView.spacing = 8

        let busImageView = UIImageView(image: UIImage(named: "itakeskus"))

        busView.addArrangedSubview(busImageView)

        let costLabel = UILabel()
        costLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        costLabel.text = "4,8 €"

        let durationLabel = UILabel()
        durationLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        durationLabel.text = "4 mins"

        let busDataView = UIStackView(arrangedSubviews: [costLabel, durationLabel])
        busView.addArrangedSubview(busDataView)

        let driverLabel = UILabel()
        driverLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        driverLabel.text = "Driver"

        let driverNameLabel = UILabel()
        driverNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        driverNameLabel.text = "Jacob M."

        self.contentStackView.addArrangedSubview(numberLabel)
        self.contentStackView.addArrangedSubview(modelLabel)
        self.contentStackView.addArrangedSubview(busView)
        self.contentStackView.addArrangedSubview(driverLabel)
        self.contentStackView.addArrangedSubview(driverNameLabel)
    }
}
