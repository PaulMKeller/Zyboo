//
//  SessionDetailTableViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 13/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class SessionDetailTableViewController: UITableViewController, ZybooItemTotalPassBackDelegate {
    
    @IBOutlet weak var sessionNavItem: UINavigationItem!
    var runningTotal: Double = 0.00
    var currentSessionObj = NSManagedObject()
    
    weak var delegate: ZybooSessionPassBackDelegate?

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

        //calculateRunningTotal()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let currentSessionItems = currentSessionObj as! SessionObj
        return (currentSessionItems.zybooItems?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "zybooItemCell", for: indexPath) as! ZybooItemTableViewCell
        
        let currentSessionItems = currentSessionObj as! SessionObj
        let sessionItems = currentSessionItems.zybooItems
        print(sessionItems!)
        //let sessionItem = sessionItems?[indexPath.row] as! ZybooItemObj
        let sessionItem = sessionItems?.object(at: indexPath.row)
        print(sessionItem!)
        let cunty = sessionItem as! ZybooItemObj
        
        
        cell.itemDescription.text = cunty.itemName
        cell.itemCount.text = String(cunty.itemCount)
        cell.itemStepper.value = Double(cunty.itemCount)
        cell.cellDataObj = cunty
        //cell.delegate = self
        
        return cell
    }
    
    func passItemDataBack() {
        // I probably need to passback the Session object at this point
    }
    
    func calculateRunningTotal() {
        
        
        runningTotal = 0.00
        
        /*
        for sessionItem: ZybooItem in self.currentSession.sessionItems {
            runningTotal = runningTotal + (Double(sessionItem.itemCount) * sessionItem.unitCost)
        }
        */
        
        sessionNavItem.title = "Total: $" + String(runningTotal)
        
    }
    
    func saveData() {
    
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
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
