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

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(vc: SearchViewController, searchText: String)
}

final class SearchViewController: UIViewController {
    weak var delegate: SearchViewControllerDelegate?

    private let whereToSearchField = UITextField()
    private let searchButton = UIButton()
    private var keyboardHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.setupSubviews()
    }

    func showKeyboard() {
        self.whereToSearchField.becomeFirstResponder()
    }

    private func setupSubviews() {
        self.view.addSubview(self.whereToSearchField)
        self.view.addSubview(self.searchButton)

        self.whereToSearchField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().offset(16)
        }

        self.searchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(self.whereToSearchField.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(60)
            make.height.equalTo(self.whereToSearchField.snp.height)
        }

        self.whereToSearchField.placeholder = "Where to?"

        self.searchButton.setTitle("Search", for: .normal)
        self.searchButton.setTitleColor(.blue, for: .normal)
        self.searchButton.addTarget(self, action: #selector(self.didTapSearchButton), for: .touchUpInside)
    }

    @objc
    private func didTapSearchButton() {
        self.view.endEditing(true)
        self.delegate?.searchViewController(vc: self, searchText: self.whereToSearchField.text ?? "")
    }
}
