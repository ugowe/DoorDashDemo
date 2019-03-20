//
//  AddressViewController.swift
//  DoorDashDemo
//
//  Created by Joseph Ugowe on 2/17/19.
//  Copyright © 2019 Joseph Ugowe. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation

class AddressViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - Properties
    
    let locationPin = MKPointAnnotation()
    let locationManager = CLLocationManager()
    var restaurantArray: [Restaurant] = []
    var locationCoordinate: CLLocationCoordinate2D?
    typealias StringCompletionBlock = (String) -> Void
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpBarButtonItem()
        self.setUpLocationManager()
        self.setUpMapView()
        self.setUpTapGesture()
    }
    
    // MARK: - Methods
    
    func retrieveAddress(_ location: CLLocation, completion: @escaping StringCompletionBlock) {
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("CLGeocoder error: \(error.localizedDescription)")
            } else  {
                guard let firstPlacemark = placemarks?.first,
                    let address = firstPlacemark.name else { return }
                
                completion(address)
            }
        }
    }
    
    @IBAction func confirmAddressButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: Constants.Segues.showExploreVCSegue, sender: self)
    }
    
    // MARK: - Private Methods
    
    private func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped(_:)))
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func mapViewTapped(_ tapGesture: UITapGestureRecognizer) {
        let tapLocation = tapGesture.location(in: mapView)
        let updatedCoordinates = mapView.convert(tapLocation, toCoordinateFrom: mapView)
        self.locationCoordinate?.latitude = updatedCoordinates.latitude
        self.locationCoordinate?.longitude = updatedCoordinates.longitude
        
        let latitudeSpan = mapView.region.span.latitudeDelta
        let longitudeSpan = mapView.region.span.longitudeDelta
        self.centerMapAroundPin(for: updatedCoordinates, latitudeSpan: latitudeSpan, longitudeSpan: longitudeSpan)
        
        let updatedLocation = CLLocation(latitude: updatedCoordinates.latitude, longitude: updatedCoordinates.longitude)
        self.retrieveAddress(updatedLocation) { (address) in
            self.addressLabel.text = address
        }
        self.locationManager.stopUpdatingLocation()
        
    }
    
    private func setUpLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setUpMapView() {
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.mapType = .standard
        
        if let coordinates = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coordinates, animated: true)
        }
    }
    
    private func setUpBarButtonItem() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: Constants.Assets.navAddress)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: Constants.Assets.navAddress)
        navigationItem.backBarButtonItem?.tintColor = Constants.Colors.doorDashRed
    }
    
    private func centerMapAroundPin(for coordinate: CLLocationCoordinate2D, latitudeSpan: Double?, longitudeSpan: Double?){
        
        self.mapView.removeAnnotation(locationPin)
        
        let latitudeDelta = latitudeSpan ?? 0.075
        let longitudeDelta = longitudeSpan ?? 0.075
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let coordinateRegion = MKCoordinateRegion(center: coordinate, span: coordinateSpan)
        
        self.mapView.setRegion(coordinateRegion, animated: true)
        self.locationCoordinate = coordinate
        self.locationPin.coordinate = coordinate
        self.mapView.addAnnotation(locationPin)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.showExploreVCSegue {
            guard let tabBar = segue.destination as? UITabBarController,
                let navigationController = tabBar.viewControllers?.first as? UINavigationController,
                let exploreVC = navigationController.viewControllers.first as? ExploreTableViewController else {
                    assertionFailure("Error segue to ExploreTableViewController")
                    return
            }
            
            exploreVC.locationCoordinate = self.locationPin.coordinate
        }
    }
    
}

// MARK: - CLLocationManager Delegate Methods

extension AddressViewController: CLLocationManagerDelegate {
    
    
    // Tells the delegate that new location data is available.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        self.retrieveAddress(location) { (address) in
            self.addressLabel.text = address
        }
        self.locationManager.stopUpdatingLocation()
        self.centerMapAroundPin(for: location.coordinate, latitudeSpan: nil, longitudeSpan: nil)
    }
}

// MARK: - MKMapView Delegate Methods

extension AddressViewController: MKMapViewDelegate {
    
     // mapView(_:viewFor:) gets called for every annotation you add to the map (just like tableView(_:cellForRowAt:) when working with table views), to return the view for each annotation. (Commented out bc of ArtworkViews)
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil}
        
        let pinIdentifier = "pinIdentifier"
        
        var pinAnnotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier) as? MKPinAnnotationView
        if pinAnnotationView == nil {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
            pinAnnotationView?.animatesDrop = true
            pinAnnotationView?.pinTintColor = Constants.Colors.doorDashRed
        }
        
        pinAnnotationView?.annotation = annotation
        return pinAnnotationView
    }
}
