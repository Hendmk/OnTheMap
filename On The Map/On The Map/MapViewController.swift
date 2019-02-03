//
//  MapViewController.swift
//  On The Map
//
//  Created by Hend Alkabani on 28/01/2019.
//  Copyright © 2019 Hend Alkabani. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var studentLocations = [StudentsLocations]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkConnection.getStudentsLocations { (errorMessage) in
            if errorMessage == nil{
                self.studentLocations = Locations.studentsInfo
                DispatchQueue.main.async {
                    self.addPins()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: errorMessage!)
                }
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.addPins()
    }
    
    
    
    func addPins() {
        guard studentLocations.count > 0 else { return }
        var annotations = [MKPointAnnotation]()
        
        for location in studentLocations {
            
            guard let latitude = location.latitude, let longitude = location.longitude else { continue }
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat , longitude: long )
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "") \(last ?? "")"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
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
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    @IBAction func logOut(_ sender: Any) {
        NetworkConnection.logout { (errorMessage) in
            if errorMessage == nil{
                AppDelegate.user.clearUser()
                DispatchQueue.main.async {
                    let TabViewController = self.storyboard?.instantiateViewController(withIdentifier: "logout")
                    UIApplication.shared.keyWindow?.rootViewController = TabViewController                }
            }
            else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: errorMessage!)
                }
            }
        }
    }
    
}
