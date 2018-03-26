//
//  SessionMapLocationViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 05/02/2018.
//  Copyright © 2018 PlanetKGames. All rights reserved.
//

import UIKit
import MapKit

class SessionMapLocationViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var currentLongitude: Double = 0.0
    var currentLatitude: Double = 0.0
    var currentSessionName: String = ""
    weak var delegate: PassBackDropPinDelegate?
    var currentAnnotation = SessionLocation(title: "",
                                            locationName: "",
                                            discipline: "",
                                            coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    
    @IBAction func mapTap(_ sender: UILongPressGestureRecognizer) {
        mapIsTapped(sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let initialLocation = CLLocation(latitude: self.currentLatitude, longitude: self.currentLongitude)
        let initialLocation = CLLocation(latitude: self.currentAnnotation.coordinate.latitude, longitude: self.currentAnnotation.coordinate.longitude)
        centerMapOnLocation(location: initialLocation)
        
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(self.currentAnnotation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map Helper Methods
    let regionRadius: CLLocationDistance = 100 //1000 meters
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapIsTapped(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        let locCoord = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        let annotation = SessionLocation(title: "", locationName: self.currentSessionName, discipline: "", coordinate: locCoord)
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(annotation)
        
        self.currentAnnotation = annotation
        
        delegate?.passBackDropPin(dropPin: annotation)
    }
    
    //Implement a pass back function to set the newly dropped pin so that it can be saved.
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
