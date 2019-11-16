//
//  BusAnnotationView.swift
//  Buber
//
//  Created by Alexey Salangin on 11/16/19.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import MapKit

class BusAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.setupImage()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImage() {
        let image = UIImage(named: "bus")?.resize(targetSize: CGSize(width: 40, height: 40))
        self.image = image?.tint(color: .systemRed)
    }
}
