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
    @IBOutlet var sessionItemCostValue: UIStepper!
    @IBAction func costStepperTapped(_ sender: UIStepper) {
        sessionItemCost.text = String(sender.value)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
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
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let entityZybooItemObj = NSEntityDescription.entity(forEntityName: "ZybooItemObj", in: managedContext)
            let newZybooItem = NSManagedObject(entity: entityZybooItemObj!, insertInto: managedContext)
            
            newZybooItem.setValue(sessionItemNameText.text, forKey: "itemName")
            newZybooItem.setValue(0, forKey: "itemCount")
            newZybooItem.setValue(sessionItemCostValue.value, forKey: "unitCost")
            
            //I need to add the item to an mutable array and then 'SetValue' on the current session object.
            //let thisSession = currentSessionObj as! SessionObj
            //thisSession.zybooItems?.add(newZybooItem)
            
            (currentSessionObj as! SessionObj).addToZybooItems(newZybooItem as! ZybooItemObj)
            print(currentSessionObj)
            
            try managedContext.save()
            _ = navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
