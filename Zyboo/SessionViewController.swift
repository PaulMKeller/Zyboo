//
//  SessionViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 2/8/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class SessionViewController: UIViewController, PassBackDropPinDelegate, CLLocationManagerDelegate {
    var currentSessionObj = NSManagedObject()
    var newSession: Bool = false
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var sessionLocation = SessionLocation(title: "", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var venueTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var includeServiceCharges: UISwitch!
    @IBAction func saveTapped(_ sender: Any) {
        if venueTextField.text == "" {
            let alert = UIAlertController(title: "Empty Venue Name", message: "Venue Name cannot be empty.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            saveData(sessionVenue: venueTextField.text!, sessionDate: datePicker.date)
        }
    }
    
    @IBAction func serviceChargesSwitched(_ sender: Any) {
    }
    
    @IBAction func addMapRefTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if venueTextField.text == "" {
            let alert = UIAlertController(title: "Empty Venue Name", message: "Venue Name cannot be empty.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.prepareForSessionDetailSegue(segueIdentifier: "mapLocationSegue")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData(){
        if self.newSession {
            datePicker.date = NSDate() as Date
            
            if CLLocationManager.locationServicesEnabled() {
                checkLocationAuthorizationStatus()
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
                //Get the users current location and set the latitude
                //and longitude
                //centerMapOnLocation(location: create a location object)
            }
            
            
        } else {
            venueTextField.text = currentSessionObj.value(forKey: "locationName") as? String
            datePicker.date = currentSessionObj.value(forKey: "sessionDate") as! Date
            includeServiceCharges.isOn = currentSessionObj.value(forKey: "applyServiceCharge") as! Bool
            latitude = currentSessionObj.value(forKey: "latitude") as! Double
            longitude = currentSessionObj.value(forKey: "longitude") as! Double
            sessionLocation.title = venueTextField.text!
            sessionLocation.locationName = venueTextField.text!
            addAnnotation()
            centerMapOnLocation(location: sessionLocation)
        }
        venueTextField.isEnabled = self.newSession
        datePicker.isEnabled = self.newSession
        includeServiceCharges.isEnabled = self.newSession
    }
    
    func saveData(sessionVenue: String, sessionDate: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            if self.newSession {
                let entitySessionObj = NSEntityDescription.entity(forEntityName: "SessionObj", in: managedContext)
                let newSessionObj = NSManagedObject(entity: entitySessionObj!, insertInto: managedContext)
                
                newSessionObj.setValue(venueTextField.text!, forKeyPath: "locationName")
                newSessionObj.setValue(datePicker.date, forKey: "sessionDate")
                newSessionObj.setValue(includeServiceCharges.isOn, forKey: "applyServiceCharge")
                newSessionObj.setValue(latitude, forKey: "latitude")
                newSessionObj.setValue(longitude, forKey: "longitude")
                currentSessionObj = newSessionObj
            } else {
                
                currentSessionObj.setValue(venueTextField.text!, forKeyPath: "locationName")
                currentSessionObj.setValue(datePicker.date, forKey: "sessionDate")
                currentSessionObj.setValue(includeServiceCharges.isOn, forKey: "applyServiceCharge")
                currentSessionObj.setValue(latitude, forKey: "latitude")
                currentSessionObj.setValue(longitude, forKey: "longitude")
            }
            
            try managedContext.save()
            _ = navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func prepareForSessionDetailSegue(segueIdentifier: String) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapLocationSegue" {
            let nextScene = segue.destination as! SessionMapLocationViewController
            nextScene.currentLatitude = self.latitude
            nextScene.currentLongitude = self.longitude
            nextScene.currentSessionName = self.venueTextField.text!
            nextScene.currentAnnotation = self.sessionLocation
            nextScene.delegate = self
        } else if segue.identifier == "sessionDetailSegue" {
            let nextScene = segue.destination as! SessionDetailTableViewController
            nextScene.currentSessionObj = self.currentSessionObj
        }
    }
    
    // MARK: - Map Helper Methods
    let regionRadius: CLLocationDistance = 100 //100 meters
    func centerMapOnLocation(location: SessionLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        locationMapView.setRegion(coordinateRegion, animated: true)
    }
    
    //let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //locationMapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        self.sessionLocation.coordinate.latitude = self.latitude
        self.sessionLocation.coordinate.longitude = self.longitude
        self.sessionLocation.locationName = self.venueTextField.text!
        addAnnotation()
        self.locationManager.stopUpdatingLocation()
        centerMapOnLocation(location: self.sessionLocation)
    }
    
    func passBackDropPin(dropPin: SessionLocation) {
        self.latitude = dropPin.coordinate.latitude
        self.longitude = dropPin.coordinate.longitude
        self.sessionLocation.locationName = self.venueTextField.text!
        self.sessionLocation.coordinate.latitude = self.latitude
        self.sessionLocation.coordinate.longitude = self.longitude
        centerMapOnLocation(location: self.sessionLocation)
        addAnnotation()
    }
    
    func addAnnotation(){
        
        let locCoord = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
        let annotation = SessionLocation(title: self.sessionLocation.title!, locationName: self.sessionLocation.locationName, discipline: "", coordinate: locCoord)
        self.locationMapView.removeAnnotations(locationMapView.annotations)
        self.locationMapView.addAnnotation(annotation)
        
        //self.currentAnnotation = annotation
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
