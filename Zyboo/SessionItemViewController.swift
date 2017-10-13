//
//  SessionItemViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 30/8/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class SessionItemViewController: UIViewController {

    var currentSessionObj = NSManagedObject()
    
    @IBOutlet weak var sessionItemNameText: UITextField!
    @IBOutlet weak var sessionItemCost: UITextField!
    @IBOutlet weak var sessionItemCostValue: UIStepper!
    @IBAction func costStepper(_ sender: UIStepper) {
        sessionItemCost.text = String(sender.value)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        /*
         Loop each Zyboo Item
         Match is it to a currentSession SessionItem
         Match that to a currentSessionObj item
         Set the values of both
         
         save the new sessionItem if it is new or update it if it is existing.
         
         Pass it back to the previous view
         */
        saveData()
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveData(){
        /*
        // Update an existing CoreData SessionObj object
        // or save a new CoreData SessionObj object
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create ZybooItemObj
        let entityZybooItemObj = NSEntityDescription.entity(forEntityName: "ZybooItemObj", in: managedContext)
        let newZybooItemObj = NSManagedObject(entity: entityZybooItemObj!, insertInto: managedContext)
        
        // Populate ZybooItemObj
        newZybooItemObj.setValue(sessionItemNameText.text, forKey: "itemName")
        newZybooItemObj.setValue(0, forKey: "itemCount")
        newZybooItemObj.setValue(sessionItemCostValue.value, forKey: "itemCost")
        newZybooItemObj.setValue(false, forKey: "favouriteItem")
        
        let zybooObjs = currentSessionObj.mutableSetValue(forKey: "zybooItems")
        zybooObjs.add(newZybooItemObj)
        
        //now seque back 
        _ = navigationController?.popViewController(animated: true)
        */
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
