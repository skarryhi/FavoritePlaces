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
    var incomeSegueIdentifire = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinMap: UIImageView!
    @IBOutlet weak var addressLable: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        setupMapView()
        checkLocationServises()
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
    }
    
    @IBAction func centerViewInUserLocation() {
        
        showUserLocation()
    }
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed() {
    }
    
    private func setupMapView() {
        if incomeSegueIdentifire == "showPlace" {
            setupPlacemark()
            pinMap.isHidden = true
            addressLable.isHidden = true
            doneButton.isHidden = true
        }
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
    
    private func showUserLocation() {
        if let location = locationManeger.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latetude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latetude, longitude: longitude)
    }
    
    private func checkLocationServises() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            alertController("Settings-> Location-> on")
        }
    }
    
    private func setupLocationManager() {
        locationManeger.delegate = self
        locationManeger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSegueIdentifire == "getAddress" { showUserLocation()}
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = getCenterLocation(for: mapView)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            let street = placemark?.thoroughfare
            let build = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                if street != nil && build != nil {
                    self.addressLable.text = "\(street!), \(build!)"
                } else if street != nil {
                    self.addressLable.text = "\(street!)"
                } else {
                    self.addressLable.text = ""
                }
                
            }
            
            
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
