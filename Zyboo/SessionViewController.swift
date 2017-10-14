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
    var currentSessionObj = NSManagedObject()
    var newSession: Bool = false
    
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
            venueTextField.text = currentSessionObj.value(forKey: "locationName") as? String
            sessionTotalLabel.text = "0.00"
            datePicker.date = currentSessionObj.value(forKey: "sessionDate") as! Date
        }
        
        venueTextField.isEnabled = self.newSession
        sessionTotalLabel.isEnabled = self.newSession
        datePicker.isEnabled = self.newSession
        
    }
    
    func passSessionDataBack(session: NSManagedObject) {
        // Pass the session back to the view controller.
        // We eventually need to reflect the session in the TrackerSessionTableViewController
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
                currentSessionObj = newSessionObj
                
                try managedContext.save()
                _ = navigationController?.popViewController(animated: true)
            
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextScene = segue.destination as! SessionDetailTableViewController
        //nextScene.newSession = self.newSession
        nextScene.currentSessionObj = self.currentSessionObj
    }

}
