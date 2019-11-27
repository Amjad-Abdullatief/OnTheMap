//
//  mapsLocationVC.swift
//  OnTheMap
//
//  Created by AMJAD - on 14/03/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit
import MapKit

class mapsLocationVC: UIViewController , MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    var location: StudentLocation?
    static let shared = mapsLocationVC()
    var selectedLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
   
    
    var mapString:String?
    var mediaURL:String?
    var latitude:Double?
    var longitude:Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupMap()
    }

    
    @IBAction func finishTapped(_ sender: Any) {
        API.shared.getUser { (success, student, errorMessage) in
            if success {
                print("student?.uniqueKey: \(student?.uniqueKey)")
                DispatchQueue.main.async {
                    self.sendInformation(student!)
                }
            } else {
                DispatchQueue.main.async {
                    print(errorMessage)
                }
            }
        }    }
    
    
    func sendInformation(_ student: StudentLocation){
        var newStudent = StudentLocation()
        newStudent.uniqueKey = student.uniqueKey
        newStudent.firstName = student.firstName
        newStudent.lastName = student.lastName
        newStudent.mapString = student.mapString
        newStudent.mediaURL = student.mediaURL
        newStudent.longitude = student.longitude
        newStudent.latitude = student.latitude
        API.shared.postStudent(newStudent) { (success, errorMessage) in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    print(errorMessage)
                }
            }
        }
    }
    
    
    private func setupMap() {
        guard let location = location else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
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

}
