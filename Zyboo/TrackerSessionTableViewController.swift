//
//  TrackerSessionTableViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 13/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class TrackerSessionTableViewController: UITableViewController, ZybooSessionPassBackDelegate {
    
    var sessionData = [Session]()
    var zybooItems: [NSManagedObject] = []
    var zybooItemObjects = [ZybooItem]()
    
    @IBAction func addTapped(_ sender: Any) {
        prepareForSessionDetailSegue(segueIdentifier: "addSessionSegue")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadData()
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
        return sessionData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath)

        var thisSession = Session()
        thisSession = sessionData[indexPath.row]
        cell.textLabel?.text = thisSession.locationName + " (" + thisSession.sessionDate + ")"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get the session data (stored locally, CoreData)
        //pass it to the next view
        //Display the data in the table
        
        //performSegue(withIdentifier: "sessionSegue", sender: self)
        prepareForSessionDetailSegue(segueIdentifier: "sessionSegue")
    }
    
    func loadData(){
        
        //Get Saved Data
        //If there is none then set up blank arrays
        //Code defensively
        
        let newSession1 = Session(sessionID: 1, locationName: "Harry's", sessionDate: "01/01/2017", sessionTotal: 0.00)
        
        sessionData.append(newSession1)
        
        let newSession2 = Session(sessionID: 2, locationName: "The Shelf Side", sessionDate: "01/08/2017", sessionTotal: 0.00)
        
        sessionData.append(newSession2)
    }
    
    func passSessionDataBack(sessionObj: Session) {
        //Do some stuff with the Session object passed back
        // Add it to the array, add it to the TableView
    }
    
    func prepareForSessionDetailSegue(segueIdentifier: String) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        createZybooItemsArray()
        
        let nextScene = segue.destination as! SessionDetailTableViewController
        if segue.identifier == "sessionSegue" {
            // Need to update itemCounts and UnitCosts of zybooItemObjects array
            // Send through to Session Details
            nextScene.sessionItems = zybooItemObjects
        }
        else if segue.identifier == "addSessionSegue" {
            nextScene.sessionItems = zybooItemObjects
         }
    }
    
    func createZybooItemsArray(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ZybooItemData")
        do {
            zybooItems = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        if zybooItems.count == 0 {
            save(itemID: 1, itemName: "Beer", itemCount: 0, unitCost: 1.00)
            save(itemID: 2, itemName: "Wine", itemCount: 0, unitCost: 2.00)
            save(itemID: 3, itemName: "Spirits", itemCount: 0, unitCost: 3.00)
            save(itemID: 4, itemName: "Mixer", itemCount: 0, unitCost: 4.00)
            save(itemID: 5, itemName: "Small Food", itemCount: 0, unitCost: 5.00)
            save(itemID: 6, itemName: "Medium Food", itemCount: 0, unitCost: 6.00)
            save(itemID: 7, itemName: "Large Food", itemCount: 0, unitCost: 7.00)
        }
        
        zybooItemObjects.removeAll()
        
        var i = 0
        while i <= zybooItems.count - 1 {
            let item = zybooItems[i]
            let zybooItem = ZybooItem()
            
            zybooItem.itemID = item.value(forKey: "itemID") as! Int32
            zybooItem.itemName = item.value(forKey: "itemName") as! String
            zybooItem.itemCount = item.value(forKey: "itemCount") as! Int32
            zybooItem.unitCost = item.value(forKey: "unitCost") as! Double
            
            zybooItemObjects.append(zybooItem)
            
            i = i + 1
        }
    }
    
    func save(itemID: Int32, itemName: String, itemCount: Int32, unitCost: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ZybooItemData",
                                                in: managedContext)!
        
        let newZybooItem = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        newZybooItem.setValue(itemID, forKeyPath: "itemID")
        newZybooItem.setValue(itemName, forKeyPath: "itemName")
        newZybooItem.setValue(itemCount, forKeyPath: "itemCount")
        newZybooItem.setValue(unitCost, forKeyPath: "unitCost")
        
        do {
            try managedContext.save()
            zybooItems.append(newZybooItem)
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
