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
    var calc = calculationFunctions()
    
    @IBOutlet weak var sessionItemCurrency: UILabel!
    @IBOutlet weak var sessionItemNameText: UITextField!
    @IBOutlet weak var sessionItemCost: UITextField!
    @IBOutlet var sessionItemCostValue: UIStepper!
    @IBAction func costStepperTapped(_ sender: UIStepper) {
        self.sessionItemCost.resignFirstResponder()
        sessionItemCost.text = String(Int(sender.value))
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if sessionItemCostValue.value == 0 {
            let alert = UIAlertController(title: "Unit Cost Error", message: "Unit cost must be greater than 0", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if sessionItemNameText.text == "" {
            let alert = UIAlertController(title: "Item Name Error", message: "The item must have a name.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if Double(sessionItemCost.text!) != sessionItemCostValue.value {
            if sessionItemCost.text == "" {
                sessionItemCost.text = String(sessionItemCostValue.value)
            } else {
                sessionItemCostValue.value = Double(sessionItemCost.text!)!
            }
            saveData()
        } else {
            saveData()
        }
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        //sessionItemNameText.autocapitalizationType = UITextAutocapitalizationType.words
        sessionItemCurrency.text = calc.currencySymbolSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            newZybooItem.setValue(1, forKey: "itemCount")
            newZybooItem.setValue(sessionItemCostValue.value, forKey: "unitCost")
            (currentSessionObj as! SessionObj).addToZybooItems(newZybooItem as! ZybooItemObj)

            try managedContext.save()
            _ = navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
