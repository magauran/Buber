//
//  SearchViewController.swift
//  Buber
//
//  Created by Alexey Salangin on 11/16/19.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit
import SnapKit
import Keyboardy

final class SearchViewController: UIViewController {
    private let whereToSearchField = UITextField()
    private var keyboardHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.setupSubviews()
    }

    private func setupSubviews() {
        self.view.addSubview(self.whereToSearchField)

        self.whereToSearchField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        self.whereToSearchField.placeholder = "Where to?"
    }
}
