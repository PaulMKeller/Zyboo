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
    var newSession: Bool = false
    var currentSession = Session()
    var currentSessionObj = NSManagedObject()
    
    weak var delegate: ZybooSessionPassBackDelegate?

    @IBAction func saveTapped(_ sender: Any) {
        saveData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        calculateRunningTotal()
        
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
        return self.currentSession.sessionItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zybooItemCell", for: indexPath) as! ZybooItemTableViewCell

        var currentItem = ZybooItem()
        currentItem = self.currentSession.sessionItems[indexPath.row]
        cell.cellItemObj = currentItem
        cell.itemDescription.text = currentItem.itemName
        cell.itemCount.text = String(currentItem.itemCount)
        cell.delegate = self

        return cell
    }
    
    func passItemDataBack(cellZybooItem: ZybooItem) {
        // I probably need to passback the Session object at this point
    }
    
    func calculateRunningTotal() {
        
        runningTotal = 0.00
        
        for sessionItem: ZybooItem in self.currentSession.sessionItems {
            runningTotal = runningTotal + (Double(sessionItem.itemCount) * sessionItem.unitCost)
        }
        
        sessionNavItem.title = "Total: $" + String(runningTotal)
    }
    
    func saveData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            /*
            if sessionData.count != 0{
                //Loop the sessionItems
                for sessionItem in sessionData {
                    //filter the session items to match the item in the array to
                    //the current managed object item
                    for item in sessionItems {
                        if sessionItem.value(forKey: "itemID") as? Int32 == item.itemID {
                            sessionItem.setValue(item.itemID, forKeyPath: "itemID")
                            sessionItem.setValue(item.itemName, forKeyPath: "itemName")
                            sessionItem.setValue(item.unitCost, forKeyPath: "itemUnitPrice")
                            sessionItem.setValue(item.itemCount, forKeyPath: "itemQuantity")
                        }
                    }
                    
                    try managedContext.save()
                    
                    self.currentSession.sessionItems = self.sessionItems
                    
                    self.delegate?.passSessionDataBack(sessionObj: self.currentSession)
                }
            } 
            */
            
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

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
