//
//  BottomContainerViewController.swift
//  Buber
//
//  Created by Alexey Salangin on 11/16/19.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit
import SnapKit

final class BottomContainerViewController: UIViewController {
    enum State {
        case search
        case order
    }

    let searchViewController = SearchViewController()
    let orderViewController = OrderViewController()

    var state: State = .search {
        didSet {
            self.updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChild(self.searchViewController)
        self.addChild(self.orderViewController)

        self.updateView()
    }

    private func updateView() {
        switch self.state {
        case .search:
            self.orderViewController.view.removeFromSuperview()
            self.view.addSubview(self.searchViewController.view)
            self.searchViewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        case .order:
            self.searchViewController.view.removeFromSuperview()
            self.view.addSubview(self.orderViewController.view)
            self.orderViewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
