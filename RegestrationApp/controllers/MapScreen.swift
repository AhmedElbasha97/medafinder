//
//  MapScreen.swift
//  RegestrationApp
//
//  Created by ahmedelbasha on 4/29/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapScreen: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    var user: [String]!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    var Address: String!
    var userImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        addBackBarButtonOnNavigationBar()
        mapView.delegate = self
    }
  
    func addBackBarButtonOnNavigationBar() {
        
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.purple
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        self.navigationController?.popViewController(animated: true)
        
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
showAlert(title: "oops something went wrong", massage: "please check your services location")
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
           showAlert(title: "please open your services location", massage: " if the appcan't take your location can't lit you in")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAlert(title: "oops something went wrong", massage: "please check your services location")
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    @IBAction func userChooseHisLocation(_ sender: Any) {
        let signUpVC = UIStoryboard.init(name: "\(Storyboards.main)", bundle: nil).instantiateViewController(withIdentifier: "\(VCs.signUpVC)") as! SignUpVC
        signUpVC.address = Address
        signUpVC.userImage = self.userImage
        signUpVC.userr = user
        signUpVC.comeFromMapScreen = true
        self.present(signUpVC, animated: true)
    }
}


extension MapScreen: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


extension MapScreen: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
      
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            let country = placemark.country ?? ""
            let city = placemark.locality ?? ""
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(country) \(city) \(streetNumber) \(streetName)"
                self.Address = "\(country) \(city) \(streetNumber) \(streetName)"
            }
        }
    }
}

    

