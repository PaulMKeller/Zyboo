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
    var sessions: [NSManagedObject] = []
    var newSessionID: Int32 = 0

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
        
        let entity = NSEntityDescription.entity(forEntityName: "SessionData",
                                                in: managedContext)!
        
        let newSessionData = NSManagedObject(entity: entity,
                                           insertInto: managedContext)
        
        newSessionData.setValue(newSessionID, forKeyPath: "sessionID")
        newSessionData.setValue(sessionVenue, forKeyPath: "locationName")
        //Set default values for long and lat for now
        //Geo locate at a later date
        newSessionData.setValue(1.277076, forKeyPath: "locationLatitude")
        newSessionData.setValue(103.846075, forKeyPath: "locationLongitude")
        //newSessionData.setValue(sessionItems, forKey: "sessionItems")
        newSessionData.setValue(datePicker.date, forKey: "sessionDate")
        
        do {
            try managedContext.save()
            sessions.append(newSessionData)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        let entityItem = NSEntityDescription.entity(forEntityName: "SessionItem",
                                                in: managedContext)!
        
        for item in sessionItems {
            let newSessionItem = NSManagedObject(entity: entityItem,
                                                 insertInto: managedContext)
            newSessionItem.setValue(newSessionID, forKeyPath: "sessionID")
            newSessionItem.setValue(item.itemCount, forKeyPath: "itemQuantity")
            newSessionItem.setValue(item.itemName, forKeyPath: "itemName")
            newSessionItem.setValue(item.itemID, forKeyPath: "itemID")
            newSessionItem.setValue(item.unitCost, forKeyPath: "itemUnitPrice")
            
            do {
                try managedContext.save()
                //sessions.append(newSessionData)
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        self.performSegue(withIdentifier: "saveSessionSegue", sender: self)
        
}
    

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextScene = segue.destination as! SessionDetailTableViewController
        nextScene.sessionItems = sessionItems
        nextScene.sessionID = newSessionID
        nextScene.newSession = true
    }

}
