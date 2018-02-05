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

class SessionViewController: UIViewController {
    var currentSessionObj = NSManagedObject()
    var newSession: Bool = false
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
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
        } else {
            venueTextField.text = currentSessionObj.value(forKey: "locationName") as? String
            datePicker.date = currentSessionObj.value(forKey: "sessionDate") as! Date
            includeServiceCharges.isOn = currentSessionObj.value(forKey: "applyServiceCharge") as! Bool
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
                currentSessionObj = newSessionObj
                
                try managedContext.save()
                _ = navigationController?.popViewController(animated: true)
            
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScene = segue.destination as! SessionDetailTableViewController
        nextScene.currentSessionObj = self.currentSessionObj
    }

}
