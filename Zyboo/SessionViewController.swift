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
    @IBOutlet var sessionTotalLabel: UILabel!
    @IBAction func saveTapped(_ sender: Any) {
        
        if venueTextField.text == "" {
            return
        }
        
        saveData(sessionVenue: venueTextField.text!, sessionDate: datePicker.date)
    }
    
    @IBAction func viewItemsTapped(_ sender: Any) {
    }
    
    var currentSession = Session()
    var currentSessionObj = NSManagedObject()
    var newSession: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        if self.newSession {
            datePicker.date = NSDate() as Date
        } else {
            venueTextField.text = self.currentSession.locationName
            sessionTotalLabel.text = String(self.currentSession.sessionTotal)
            datePicker.date = self.currentSession.sessionDate
        }
        
    }
    
    func passSessionDataBack(sessionObj: Session) {
        // Pass the session back to the view controller.
        // We eventually need to reflect the session in the TrackerSessionTableViewController
    }
    
    
    /*
    func saveData(sessionVenue: String, sessionDate: Date) {
        // Update an existing CoreData SessionObj object
        // or save a new CoreData SessionObj object
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "SessionObj",
                                                in: managedContext)!
        
        if newSession {
            let newSessionData = NSManagedObject(entity: entity,
                                                 insertInto: managedContext)
            
            newSessionData.setValue(self.venueTextField.text, forKeyPath: "locationName")
            newSessionData.setValue(1.277076, forKeyPath: "locationLatitude")       //Geo-locate the session later
            newSessionData.setValue(103.846075, forKeyPath: "locationLongitude")    //Geo-locate the session later
            newSessionData.setValue(datePicker.date, forKey: "sessionDate")
            newSessionData.setValue(sessionTotalLabel.text, forKey: "sessionTotal")
            newSessionData.setValue(self.currentSession.sessionItems, forKey: "sessionItems")
        } else {
            self.currentSessionObj.setValue(self.venueTextField.text, forKeyPath: "locationName")
            self.currentSessionObj.setValue(1.277076, forKeyPath: "locationLatitude")       //Geo-locate the session later
            self.currentSessionObj.setValue(103.846075, forKeyPath: "locationLongitude")    //Geo-locate the session later
            self.currentSessionObj.setValue(datePicker.date, forKey: "sessionDate")
            self.currentSessionObj.setValue(sessionTotalLabel.text, forKey: "sessionTotal")
            self.currentSessionObj.setValue(self.currentSession.sessionItems, forKey: "sessionItems")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.performSegue(withIdentifier: "saveSessionSegue", sender: self)
        
    }
     */
    
    
    /* VERSION 2...
    func saveData(sessionVenue: String, sessionDate: Date) {
        // Update an existing CoreData SessionObj object
        // or save a new CoreData SessionObj object
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Use a fetch request with predicate to retrieve the object
        // If nothing it found, create a new one, else update the existing one.
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SessionObj")
        // I probably should do this with ObjectID...
        fetchRequest.predicate = NSPredicate(format: "locationName = %@ AND sessionDate = %@", currentSession.locationName, currentSession.sessionDate as CVarArg)
        
        do {
            var sessionItemsFetched: [NSManagedObject] = []
            sessionItemsFetched = try managedContext.fetch(fetchRequest)

            self.currentSession.locationName = self.venueTextField.text!
            self.currentSession.sessionDate = datePicker.date
            self.currentSession.sessionTotal = Double(self.sessionTotalLabel.text!)!
            //session items can't of changed at this point...
            
            if sessionItemsFetched.count == 0 && newSession == true {
                //It's a new session
                let entity = NSEntityDescription.entity(forEntityName: "SessionObj",
                                                        in: managedContext)!
                
                let newSession = NSManagedObject(entity: entity,
                                                   insertInto: managedContext)
                
                newSession.setValue(self.venueTextField.text, forKeyPath: "locationName")
                newSession.setValue(1.277076, forKeyPath: "locationLatitude")       //Geo-locate the session later
                newSession.setValue(103.846075, forKeyPath: "locationLongitude")    //Geo-locate the session later
                newSession.setValue(datePicker.date, forKey: "sessionDate")
                newSession.setValue(Double(self.sessionTotalLabel.text!), forKey: "sessionTotal")
                //newSession.setValue(self.currentSession.sessionItems, forKey: "sessionItems")
            } else {
                for thisSession in sessionItemsFetched {
                    thisSession.setValue(self.venueTextField.text, forKeyPath: "locationName")
                    thisSession.setValue(1.277076, forKeyPath: "locationLatitude")       //Geo-locate the session later
                    thisSession.setValue(103.846075, forKeyPath: "locationLongitude")    //Geo-locate the session later
                    thisSession.setValue(datePicker.date, forKey: "sessionDate")
                    thisSession.setValue(Double(self.sessionTotalLabel.text!), forKey: "sessionTotal")
                    //thisSession.setValue(self.currentSession.sessionItems, forKey: "sessionItems")
                }
            }
        
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.performSegue(withIdentifier: "saveSessionSegue", sender: self)
        
    }
    */
    
    func saveData(sessionVenue: String, sessionDate: Date) {
        // Update an existing CoreData SessionObj object
        // or save a new CoreData SessionObj object
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            self.currentSession.locationName = self.venueTextField.text!
            self.currentSession.sessionDate = datePicker.date
            self.currentSession.sessionTotal = Double(self.sessionTotalLabel.text!)!
            
            currentSessionObj.setValue(self.venueTextField.text, forKeyPath: "locationName")
            currentSessionObj.setValue(1.277076, forKeyPath: "locationLatitude")       //Geo-locate the session later
            currentSessionObj.setValue(103.846075, forKeyPath: "locationLongitude")    //Geo-locate the session later
            currentSessionObj.setValue(datePicker.date, forKey: "sessionDate")
            currentSessionObj.setValue(Double(self.sessionTotalLabel.text!), forKey: "sessionTotal")
            
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.performSegue(withIdentifier: "saveSessionSegue", sender: self)
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextScene = segue.destination as! SessionDetailTableViewController
        nextScene.newSession = self.newSession
        nextScene.currentSession = self.currentSession
    }

}
