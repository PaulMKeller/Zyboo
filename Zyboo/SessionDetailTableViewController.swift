//
//  SessionDetailTableViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 13/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class SessionDetailTableViewController: UITableViewController, TriggerZybooItemSaveDelegate {
    
    @IBOutlet weak var sessionNavItem: UINavigationItem!
    var runningTotal: Double = 0
    var currentSessionObj = NSManagedObject()
    var calc = calculationFunctions()

    @IBAction func saveTapped(_ sender: Any) {
        saveData()
    }

    @IBAction func addTapped(_ sender: Any) {
        prepareForItemSegue(segueIdentifier: "addItemSegue", segueSessionObj: currentSessionObj)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView!.reloadData()
        calc.loadData()
        calculateRunningTotal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSessionItems = currentSessionObj as! SessionObj
        return (currentSessionItems.zybooItems?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "zybooItemCell", for: indexPath) as! ZybooItemTableViewCell
        
        let currentSessionItems = currentSessionObj as! SessionObj
        let sessionItem = currentSessionItems.zybooItems?.object(at: indexPath.row) as! ZybooItemObj
        var applyCharges:String = ""
        
        if  currentSessionItems.applyServiceCharge {
            applyCharges = " plus charges"
        }
        
        cell.itemDescription.text = sessionItem.itemName! + " (" + calc.currencySymbolSetting() + String(Int(sessionItem.unitCost)) + applyCharges + ")"
        cell.itemCount.text = String(sessionItem.itemCount)
        cell.itemStepper.value = Double(sessionItem.itemCount)
        cell.cellDataObj = sessionItem
        cell.delegate = self
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            do {
                let currentSessionItems = currentSessionObj as! SessionObj
                let sessionItem = currentSessionItems.zybooItems?.object(at: indexPath.row) as! ZybooItemObj
                managedContext.delete(sessionItem)
                currentSessionItems.zybooItems?.removeObject(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                try managedContext.save()
                calculateRunningTotal()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func triggerItemSave() {
        saveData()
    }
    
    func calculateRunningTotal() {
        sessionNavItem.title = calc.calculateRunningTotal(thisSessionObj: self.currentSessionObj as! SessionObj)
    }
    
    func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            calculateRunningTotal()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func prepareForItemSegue(segueIdentifier: String, segueSessionObj: NSManagedObject) {
        self.currentSessionObj = segueSessionObj
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemSegue" {
            let nextScene = segue.destination as! SessionItemViewController
            nextScene.currentSessionObj = self.currentSessionObj
        }
        
    }
    
    /*
    func createAlert(successfulSave: Bool) {
        
        let alertMessage: String
        
        if successfulSave {
            alertMessage = "Data Saved"
        } else {
            alertMessage = "Data NOT Saved"
        }
        
        // create the alert
        let alert = UIAlertController(title: "Session Save", message: "\(alertMessage)", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
     */
    
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
