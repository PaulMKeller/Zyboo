//
//  NewChargeViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 22/10/2017.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class NewChargeViewController: UIViewController {
    
    var newChargeObj = NSManagedObject()
    var applicationOrder:Int16 = 0

    @IBOutlet weak var chargeName: UITextField!
    @IBOutlet weak var percentageValue: UILabel!
    @IBOutlet weak var stepperValue: UIStepper!
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        percentageValue.text = String(Int16(sender.value))
    }
    @IBOutlet weak var switchValue: UISwitch!

    @IBAction func saveTapped(_ sender: Any) {
        if chargeName.text != "" && stepperValue.value != 0 {
            saveData()
        } else {
            let alert = UIAlertController(title: "Empty Charge Name", message: "Charge Name cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //chargeName.autocapitalizationType = UITextAutocapitalizationType.words
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let entityServiceChargeObj = NSEntityDescription.entity(forEntityName: "ServiceChargeObj", in: managedContext)
            let newSrvChg = NSManagedObject(entity: entityServiceChargeObj!, insertInto: managedContext)
            
            newSrvChg.setValue(chargeName.text, forKey: "chargeName")
            newSrvChg.setValue(Int16(stepperValue.value), forKey: "percentageCharge")
            newSrvChg.setValue(applicationOrder, forKey: "applicationOrder")
            newSrvChg.setValue(switchValue.isOn, forKey: "isOn")
            
            try managedContext.save()
            _ = navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
