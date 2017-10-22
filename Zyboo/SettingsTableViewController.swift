//
//  SettingsTableViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 19/07/2017.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class SettingsTableViewController: UITableViewController {

    var settingObjs = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        initialDataSetUp()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingObjs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        let thisSetting = settingObjs[indexPath.row] as! SettingObj
        
        cell.textLabel?.text = thisSetting.settingName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisSetting = settingObjs[indexPath.row] as! SettingObj
        if thisSetting.settingName == "Additional Charges" {
            prepareForSegue(segueIdentifier: "chargesSegue")
        } else if thisSetting.settingName == "Currency" {
            prepareForSegue(segueIdentifier: "currencySegue")
        } else {
            //Something has gone wrong
        }
    }
    
    func prepareForSegue(segueIdentifier: String) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chargesSegue" {
            _ = segue.destination as! ChargesTableViewController
        } else if segue.identifier == "chargesSegue" {
            //let nextScene = segue.destination as! SessionDetailTableViewController
        }
        
    }
    
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SettingObj")
        let sort = NSSortDescriptor(key: "settingName", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        //fetchRequest.propertiesToGroupBy = ["sessionGroup"]
        do {
            settingObjs.removeAll()
            settingObjs = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func initialDataSetUp() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SettingObj")
            let settings = try managedContext.fetch(fetchRequest)
            
            if settings.count == 0 {
                let entitySettingObj = NSEntityDescription.entity(forEntityName: "SettingObj", in: managedContext)
                let newSettingObj = NSManagedObject(entity: entitySettingObj!, insertInto: managedContext)
                
                newSettingObj.setValue("General", forKeyPath: "settingGroup")
                newSettingObj.setValue("Additional Charges", forKey: "settingName")
                
                /*
                let newSettingObj2 = NSManagedObject(entity: entitySettingObj!, insertInto: managedContext)
                newSettingObj2.setValue("General", forKeyPath: "settingGroup")
                newSettingObj2.setValue("Currency", forKey: "settingName")
                 */
            }
            
            let serviceChargeFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ServiceChargeObj")
            let serviceCharges = try managedContext.fetch(serviceChargeFetchRequest)
            
            if serviceCharges.count == 0 {
                let entityServiceChargeObj = NSEntityDescription.entity(forEntityName: "ServiceChargeObj", in: managedContext)
                let newServiceChargeObj = NSManagedObject(entity: entityServiceChargeObj!, insertInto: managedContext)
                newServiceChargeObj.setValue("Service Charge %", forKey: "chargeName")
                newServiceChargeObj.setValue(10, forKey: "percentageCharge")
                newServiceChargeObj.setValue(true, forKey: "isOn")
                newServiceChargeObj.setValue(1, forKey: "applicationOrder")
                
                let newServiceChargeObj2 = NSManagedObject(entity: entityServiceChargeObj!, insertInto: managedContext)
                newServiceChargeObj2.setValue("Sales Tax %", forKey: "chargeName")
                newServiceChargeObj2.setValue(7, forKey: "percentageCharge")
                newServiceChargeObj2.setValue(true, forKey: "isOn")
                newServiceChargeObj2.setValue(2, forKey: "applicationOrder")
            }
            
            let currencyFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrencyObj")
            let currencies = try managedContext.fetch(currencyFetchRequest)
            
            if currencies.count == 0 {
                let entityCurrencyObj = NSEntityDescription.entity(forEntityName: "CurrencyObj", in: managedContext)
                let newCurrencyObj = NSManagedObject(entity: entityCurrencyObj!, insertInto: managedContext)
                
                newCurrencyObj.setValue("Singapore Dollars", forKeyPath: "currencyName")
                newCurrencyObj.setValue("$", forKey: "currencySymbol")
                newCurrencyObj.setValue("SGD", forKey: "currencyInitials")
                newCurrencyObj.setValue(true, forKey: "isOn")
                
                let newCurrencyObj2 = NSManagedObject(entity: entityCurrencyObj!, insertInto: managedContext)
                
                newCurrencyObj2.setValue("US Dollars", forKeyPath: "currencyName")
                newCurrencyObj2.setValue("$", forKey: "currencySymbol")
                newCurrencyObj2.setValue("USD", forKey: "currencyInitials")
                newCurrencyObj.setValue(false, forKey: "isOn")
                
                let newCurrencyObj3 = NSManagedObject(entity: entityCurrencyObj!, insertInto: managedContext)
                
                newCurrencyObj3.setValue("Euros", forKeyPath: "currencyName")
                newCurrencyObj3.setValue("€", forKey: "currencySymbol")
                newCurrencyObj3.setValue("EUR", forKey: "currencyInitials")
                newCurrencyObj.setValue(false, forKey: "isOn")
                
                let newCurrencyObj4 = NSManagedObject(entity: entityCurrencyObj!, insertInto: managedContext)
                
                newCurrencyObj4.setValue("British Pounds", forKeyPath: "currencyName")
                newCurrencyObj4.setValue("£", forKey: "currencySymbol")
                newCurrencyObj4.setValue("GBP", forKey: "currencyInitials")
                newCurrencyObj.setValue(false, forKey: "isOn")
            }
            
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        /*else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }*/
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
