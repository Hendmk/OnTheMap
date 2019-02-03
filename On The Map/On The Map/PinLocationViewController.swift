//
//  PinLocationViewController.swift
//  On The Map
//
//  Created by Hend Alkabani on 29/01/2019.
//  Copyright © 2019 Hend Alkabani. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PinLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userLocation: UITextField!
    @IBOutlet weak var userURL: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submit: UIButton!
    var mediaURL = ""
    var latitu = 0.0
    var longit = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submit.isHidden = true
        userURL.delegate = self
        userLocation.delegate = self
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    @IBAction func findOnMap(_ sender: Any) {
       let Ind = self.startAnActivityIndicator()

        mediaURL = userURL.text!
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(userLocation.text!) {
            placemarks, error in
            guard let placemark = placemarks?.first,
                let lat = placemark.location?.coordinate.latitude,
                let lon = placemark.location?.coordinate.longitude
                else {
                    self.showAlert(title: "Error", message: "Cannot find the location")
                    return
            }
            self.latitu = lat
            self.longit = lon
            
            self.showPins(lati: lat, long: lon)
            DispatchQueue.main.async {
                self.submit.isHidden = false
              Ind.stopAnimating()
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
            goToMap()
    }
    
    
    func showPins(lati: Double, long: Double) {
        var annotations = [MKPointAnnotation]()
            let lat = CLLocationDegrees(lati)
            let long = CLLocationDegrees(long)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat , longitude: long )
            
            let first = AppDelegate.user.firstName
            let last = AppDelegate.user.lastName
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "") \(last ?? "")"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
        mapView.addAnnotations(annotations)

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    @IBAction func clickSubmit(_ sender: Any) {
        NetworkConnection.putStudentLocation(lat: latitu, lon: longit, mapString: self.userLocation.text!, mediaURL: self.userURL.text!){
            (errorMessage) in
            if errorMessage == nil{
                DispatchQueue.main.async {
                self.goToMap()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: errorMessage!)
                }
            }
        }
    }
    
    func goToMap() {
        let TabViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = TabViewController
    }
}




extension UIViewController {
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(ai)
        self.view.bringSubviewToFront(ai)
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }
}
