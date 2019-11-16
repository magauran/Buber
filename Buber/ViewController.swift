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
import CoreGPX

final class ViewController: UIViewController {
    private let mapView = MKMapView()
    private let fpc = FloatingPanelController()
    private let searchViewController = SearchViewController()
    private lazy var userTraсkingButton = UIButton()
    private var userCoordinate: CLLocationCoordinate2D?

    private let myAnnotation = BusAnnotation(route: [
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
        self.mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.view.addSubview(self.userTraсkingButton)
        self.userTraсkingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        self.setupMapView()
        self.setupSearchVC()
        self.setupFPC()
        self.setupUserTrackingButton()
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

        if let userCoordinate = self.getUserCoordinate() {
            let userAnnotation = UserAnnotation()
            userAnnotation.coordinate = userCoordinate
            self.mapView.addAnnotation(userAnnotation)
        }

        let busStopsCoordinates = self.getBusStopsCoordinates()
        let busStopsAnnotations: [BusStopAnnotation] = busStopsCoordinates.map { coordinate in
            let annotation = BusStopAnnotation()
            annotation.coordinate = coordinate
            return annotation
        }
        self.mapView.addAnnotations(busStopsAnnotations)
    }

    private func setupSearchVC() {
        self.searchViewController.delegate = self
    }

    private func setupFPC() {
        self.fpc.surfaceView.backgroundColor = .clear
        self.fpc.surfaceView.cornerRadius = 16
        self.fpc.surfaceView.shadowHidden = false
    }

    private func setupUserTrackingButton() {
        self.userTraсkingButton.backgroundColor = .red
        self.userTraсkingButton.addTarget(self, action: #selector(self.didTapUserTrackingButton), for: .touchUpInside)
    }

    private func getUserCoordinate() -> CLLocationCoordinate2D? {
        let data = NSDataAsset(name: "UserLocation")!.data
        let parser = GPXParser(withData: data)
        guard
            let point = parser.parsedData()?.waypoints.first,
            let latitude = point.latitude,
            let longitude = point.longitude
        else {
            return nil
        }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.userCoordinate = coordinate
        return coordinate
    }

    private func getBusStopsCoordinates() -> [CLLocationCoordinate2D] {
        return [
            CLLocationCoordinate2D(latitude: 53.5, longitude: -6.2),
            CLLocationCoordinate2D(latitude: 53.9, longitude: -6.4),
            CLLocationCoordinate2D(latitude: 52.8, longitude: -6.0),
            CLLocationCoordinate2D(latitude: 52.6, longitude: -6.3),
        ]
    }

    @objc
    private func didTapUserTrackingButton() {
        guard let userCoordinate = self.getUserCoordinate() else { return }
        self.mapView.setCenter(userCoordinate, animated: true)
    }

    private func showRoute(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)

        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }

            let route = response.routes[0]

            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
        }
    }

    private func removeAllRoutes() {
        self.mapView.overlays.filter { $0 is MKPolyline }.forEach { overlay in
            self.mapView.removeOverlay(overlay)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is MKUserLocation: return nil
        case is BusAnnotation:
            let identifier = "Pin"
            var annotationView: BusAnnotationView?
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? BusAnnotationView {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = BusAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            return annotationView
        case is BusStopAnnotation:
            let identifier = "BusStop"
            var annotationView: BusStopAnnotationView?
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? BusStopAnnotationView {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = BusStopAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            return annotationView
        case is UserAnnotation:
            return UserAnnotationView(annotation: annotation, reuseIdentifier: "User")
        default:
            return nil
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is BusStopAnnotationView else { return }
        guard let destinationCoordinate = view.annotation?.coordinate else { return }
        guard let pickupCoordinate = self.userCoordinate else { return }

        self.removeAllRoutes()
        self.showRoute(pickupCoordinate: pickupCoordinate, destinationCoordinate: destinationCoordinate)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .yellow
        renderer.lineWidth = 5.0
        return renderer
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
