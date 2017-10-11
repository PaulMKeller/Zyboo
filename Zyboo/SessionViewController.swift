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
        
        self.performSegue(withIdentifier: "saveSessionSegue", sender: self)
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
    
    func saveData(sessionVenue: String, sessionDate: Date) {
        // Update an existing CoreData SessionObj object
        // or save a new CoreData SessionObj object
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            self.currentSession.locationName = venueTextField.text!
            self.currentSession.sessionDate = datePicker.date
            self.currentSession.sessionTotal = Double(sessionTotalLabel.text!)!
            
            if self.newSession {
                let entitySessionObj = NSEntityDescription.entity(forEntityName: "SessionObj", in: managedContext)
                let newSessionObj = NSManagedObject(entity: entitySessionObj!, insertInto: managedContext)
                
                newSessionObj.setValue(venueTextField.text!, forKeyPath: "locationName")
                newSessionObj.setValue(1.277076, forKeyPath: "locationLatitude")       //Geo-locate the session later
                newSessionObj.setValue(103.846075, forKeyPath: "locationLongitude")    //Geo-locate the session later
                newSessionObj.setValue(datePicker.date, forKey: "sessionDate")
                newSessionObj.setValue(Double(sessionTotalLabel.text!), forKey: "sessionTotal")
                currentSessionObj = newSessionObj
                
                try managedContext.save()
                _ = navigationController?.popViewController(animated: true)
            }
            /*
             else {
                // I don't need to do this. Only save new sessions or delete.
                // Don't allow sessions to be edited
                currentSessionObj.setValue(venueTextField.text!, forKeyPath: "locationName")
                currentSessionObj.setValue(1.277076, forKeyPath: "locationLatitude")       //Geo-locate the session later
                currentSessionObj.setValue(103.846075, forKeyPath: "locationLongitude")    //Geo-locate the session later
                currentSessionObj.setValue(datePicker.date, forKey: "sessionDate")
                currentSessionObj.setValue(Double(sessionTotalLabel.text!), forKey: "sessionTotal")
                
                try managedContext.save()
 
            }
            */
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        //self.performSegue(withIdentifier: "saveSessionSegue", sender: self)
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextScene = segue.destination as! SessionDetailTableViewController
        nextScene.newSession = self.newSession
        nextScene.currentSession = self.currentSession
        nextScene.currentSessionObj = self.currentSessionObj
    }

}
