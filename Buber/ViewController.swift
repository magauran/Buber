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
    private let searchViewController = SearchViewController()

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

        self.setupMapView()
        self.setupSearchVC()
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

        self.fpc.set(contentViewController: self.searchViewController)
        self.fpc.delegate = self
        self.present(self.fpc, animated: true, completion: nil)
    }

    private func setupMapView() {
        let startPosition = CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603)

        let region = MKCoordinateRegion(center: startPosition, latitudinalMeters: 100000, longitudinalMeters: 100000)
        self.mapView.setRegion(region, animated: true)

        myAnnotation.coordinate = startPosition
        self.mapView.addAnnotation(myAnnotation)

        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = CLLocationCoordinate2D(latitude: 53.1, longitude: -6.26)
        self.mapView.addAnnotation(userAnnotation)
    }

    private func setupSearchVC() {
        self.searchViewController.delegate = self
    }

    private func setupFPC() {
        self.fpc.surfaceView.backgroundColor = .clear
        self.fpc.surfaceView.cornerRadius = 16
        self.fpc.surfaceView.shadowHidden = false
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is MKUserLocation: return nil
        case is MovingAnnotation:
            let identifier = "Pin"
            var annotationView: BusAnnotationView?
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? BusAnnotationView {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = BusAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            return annotationView
        default:
            return UserAnnotationView(annotation: annotation, reuseIdentifier: "User")
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
                return 380
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

extension ViewController: SearchViewControllerDelegate {
    func searchViewController(vc: SearchViewController, searchText: String) {
        self.fpc.move(to: .tip, animated: true)
    }
}
