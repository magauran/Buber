//
//  ViewController.swift
//  Buber
//
//  Created by Alexey Salangin on 11/15/19.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel
import Keyboardy

final class ViewController: UIViewController {
    private let mapView = MKMapView()
    private let fpc = FloatingPanelController()

    private let myAnnotation = MovingAnnotation(route: [
        CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603),
        CLLocationCoordinate2D(latitude: 53.2369, longitude: -6.3633),
        CLLocationCoordinate2D(latitude: 53.1369, longitude: -6.4633),
        CLLocationCoordinate2D(latitude: 52.8369, longitude: -6.5633),
        CLLocationCoordinate2D(latitude: 52.6369, longitude: -6.6633),
        CLLocationCoordinate2D(latitude: 52.5369, longitude: -6.5633),
        CLLocationCoordinate2D(latitude: 52.3369, longitude: -6.4633),
    ])

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self

        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mapView)
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])

        let startPosition = CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603)

        let region = MKCoordinateRegion(center: startPosition, latitudinalMeters: 100000, longitudinalMeters: 100000)
        mapView.setRegion(region, animated: true)

        // Add annotation to map.
        myAnnotation.coordinate = startPosition
        mapView.addAnnotation(myAnnotation)


        self.setupFPC()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterFromKeyboardNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.myAnnotation.start()

        let search = SearchViewController()
        self.fpc.set(contentViewController: search)
        self.fpc.delegate = self
        self.present(self.fpc, animated: true, completion: nil)
    }

    private func setupFPC() {
        self.fpc.surfaceView.backgroundColor = .clear
        self.fpc.surfaceView.cornerRadius = 16
        self.fpc.surfaceView.shadowHidden = false
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let identifier = "Pin"
            var annotationView: MKAnnotationView?
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                let image = UIImage(named: "bus")?.resize(targetSize: CGSize(width: 40, height: 40))
                annotationView?.image = image?.tint(color: .systemRed)
            }

            return annotationView
        }
    }
}


extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let image = self
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


extension UIImage {
    func tint(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}

// MARK: - FloatingPanelControllerDelegate
extension ViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return MyFloatingPanelLayout()
    }

    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if self.fpc.position == .half {
            self.fpc.view.endEditing(true)
        }
    }

    func floatingPanelWillBeginDecelerating(_ vc: FloatingPanelController) {
        if self.fpc.position == .half {
            self.fpc.view.endEditing(true)
        }
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .full: return 16.0
            case .half:
                return 500
            case .tip: return 50
            default: return nil
        }
    }
}

extension ViewController: KeyboardStateDelegate {
    func keyboardWillTransition(_ state: KeyboardState) {
    }

    func keyboardTransitionAnimation(_ state: KeyboardState) {
        switch state {
        case .activeWithHeight:
            self.fpc.move(to: .half, animated: true)
        case .hidden:
            self.fpc.move(to: .tip, animated: true)
        }
    }


    func keyboardDidTransition(_ state: KeyboardState) {
        // keyboard animation finished
    }
}
