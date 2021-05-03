//
//  MapViewController.swift
//  FavoritePlaces
//
//  Created by Анна Заблуда on 03.05.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    var place = Place()
    var annatationIdentifire = "annatationIdentifire"
    let locationManeger = CLLocationManager()
    let regionInMeters = 8_000.00
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        setupPlacemark()
        checkLocationServises()
    }
    
    @IBAction func centerViewInUserLocation() {
        
        if let location = locationManeger.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    private func setupPlacemark() {
        
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    private func checkLocationServises() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAccuracyAuthorization()
        } else {
            alertController("Settings-> Location-> on")
        }
    }
    
    private func setupLocationManager() {
        locationManeger.delegate = self
        locationManeger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAccuracyAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        case .denied:
            alertController("Settings-> Privacy-> Enable Location Service [FavoritePlaces] to enable the location")
            break
        case .notDetermined:
            locationManeger.requestWhenInUseAuthorization()
        case .restricted:
            alertController("Settings-> Privacy-> Enable Location Service [FavoritePlaces] to enable the location")
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is available")
        }
        
    }
    
    private func alertController(_ message: String) {
        let alert = UIAlertController(title: "Location service is disabled", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annatationIdentifire") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annatationIdentifire")
            annotationView?.canShowCallout = true
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.image = UIImage(data: place.imageData!)
        annotationView?.rightCalloutAccessoryView = imageView
        
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAccuracyAuthorization()
    }
}
