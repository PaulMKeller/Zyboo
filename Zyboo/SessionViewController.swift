//
//  SessionViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 2/8/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class SessionViewController: UIViewController, ZybooSessionPassBackDelegate {
    
    
    @IBOutlet weak var venueTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func saveTapped(_ sender: Any) {
        
        if venueTextField.text == "" {
            return
        }
        
        saveData(sessionVenue: venueTextField.text!, sessionDate: datePicker.date)
    }
    
    var sessionObj = Session()
    var sessionItems = [ZybooItem]()
    var locations: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.date = NSDate() as Date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func passSessionDataBack(sessionObj: Session) {
        //Pass the session back to the view controller.
    }
    
    func saveData(sessionVenue: String, sessionDate: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Location",
                                                in: managedContext)!
        
        let newSessionItem = NSManagedObject(entity: entity,
                                           insertInto: managedContext)
        
        //Need to set a LocationID somehow
        newSessionItem.setValue(sessionVenue, forKeyPath: "locationName")
        //Set default values for long and lat for now
        
        do {
            try managedContext.save()
            locations.append(newSessionItem)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        //Now save the sessions data with the new location data
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
