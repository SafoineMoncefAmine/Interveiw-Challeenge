//
//  ViewController.swift
//  Avito Challenge
//
//  Created by Safoine Moncef Amine on 27/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController , CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var isNearButton: UIButton!
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 500000
    let issNearRegionRadius: CLLocationDistance = 10000
    let annotation = MKPointAnnotation()

    var issLocation: CLLocation {
        let latitude = Double(self.latitude)!
        let longitude = Double(self.longitude)!
        return CLLocation(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)
    }
    var latitude : String = ""
    var longitude : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(MapViewController.updateIssLocation), userInfo: nil, repeats: true)
        configure()
    }
    
    func configure() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func checkIfIssIsNear() {
        
        if (CLLocationManager.locationServicesEnabled() && locationManager.location != nil) {
            if locationManager.location!.distance(from: issLocation) > issNearRegionRadius {
                DispatchQueue.main.async {
                    self.isNearButton.backgroundColor = UIColor.red
                }
            }else {
                DispatchQueue.main.async {
                    self.isNearButton.backgroundColor = UIColor.green
                }
            }
        }
    }
    
    @objc private func updateIssLocation(){
        ISSApi.shared.getCurrentISSLocation { (latitude, longitude) -> Void in
            self.latitude = latitude
            self.longitude = longitude
            DispatchQueue.main.async {
                self.annotation.coordinate = self.issLocation.coordinate
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotation(self.annotation)
            }
            self.checkIfIssIsNear()
        }
    }
    

    @IBAction func centerMapOnISS(_ sender: Any) {
        let coordinateRegion = MKCoordinateRegion(center:issLocation.coordinate,latitudinalMeters:regionRadius,longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func showIssPassengers(_ sender: Any) {
        performSegue(withIdentifier: "showPassengers", sender: self)
    }
    
}

