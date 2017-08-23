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
    
    var sessionItems = [Session]()
    var sessionData: [NSManagedObject] = []
    
    var zybooItems: [NSManagedObject] = []
    var zybooItemObjects = [ZybooItem]()
    
    var currentSessionID: Int32 = 0
    var currentSession = Session()
    
    @IBAction func addTapped(_ sender: Any) {
        prepareForSessionDetailSegue(segueIdentifier: "addSessionSegue", sessionID: 0, currentSession: currentSession)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView!.reloadData()
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
        return sessionItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath)

        var thisSession = Session()
        thisSession = sessionItems[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        cell.textLabel?.text = thisSession.locationName + " (" + String(describing: dateFormatter.string(from: thisSession.sessionDate)) + ")"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get the session data (stored locally, CoreData)
        //pass it to the next view
        //Display the data in the table
        
        //performSegue(withIdentifier: "sessionSegue", sender: self)
        currentSession = sessionItems[indexPath.row]
        prepareForSessionDetailSegue(segueIdentifier: "sessionSegue", sessionID: Int32(indexPath.row), currentSession: currentSession)
    }
    
    func loadData(){
        
        //Get Saved Data
        //If there is none then set up blank arrays
        //Code defensively
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SessionData")
        do {
            sessionData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if sessionData.count != 0 {
            sessionItems.removeAll()
            
            var i = 0
            while i <= sessionData.count - 1 {
                let item = sessionData[i]
                let sessionHistory = Session()
                
                sessionHistory.locationName = item.value(forKey: "locationName") as! String
                sessionHistory.sessionDate = item.value(forKey: "sessionDate") as! Date
                sessionHistory.sessionID = item.value(forKey: "sessionID") as! Int64
                
                let sessionItemsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SessionItem")
                sessionItemsFetchRequest.predicate = NSPredicate(format: "sessionID = %@", String(sessionHistory.sessionID))
                var sessionItemsFetched: [NSManagedObject] = []
                
                do {
                    sessionItemsFetched = try managedContext.fetch(sessionItemsFetchRequest)
                    
                    //sessionHistory.sessionTotal = sessionItemsFetched[0].value(forKey: "")
                    for thisSessionItem in sessionItemsFetched {
                        let newZybooItem = ZybooItem()
                        newZybooItem.itemID = Int32(thisSessionItem.value(forKey: "itemID") as! Int64)
                        newZybooItem.itemName = thisSessionItem.value(forKey: "itemName") as! String
                        newZybooItem.itemCount = thisSessionItem.value(forKey: "itemQuantity") as! Int32
                        newZybooItem.unitCost = thisSessionItem.value(forKey: "itemUnitPrice") as! Double
                        
                        sessionHistory.sessionItems.append(newZybooItem)
                    }
                    
                    self.currentSession = sessionHistory
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
                sessionItems.append(sessionHistory)
                
                i = i + 1
            }
        }
    }
    
    func passSessionDataBack(sessionObj: Session) {
        //Do some stuff with the Session object passed back
        // Add it to the array, add it to the TableView
        self.currentSession = sessionObj
        self.tableView?.reloadData()
    }
    
    func prepareForSessionDetailSegue(segueIdentifier: String, sessionID: Int32, currentSession: Session) {
        self.currentSessionID = sessionID
        self.currentSession = currentSession
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        createZybooItemsArray()
        
        if segue.identifier == "sessionSegue" {
            // Need to update itemCounts and UnitCosts of zybooItemObjects array
            // Send through to Session Details
            let nextScene = segue.destination as! SessionDetailTableViewController
            nextScene.sessionItems = zybooItemObjects
            nextScene.newSession = false
            nextScene.sessionID = self.currentSessionID
            nextScene.currentSession = self.currentSession
        }
        else if segue.identifier == "addSessionSegue" {
            let nextScene = segue.destination as! SessionViewController
            nextScene.sessionItems = zybooItemObjects
            nextScene.newSessionID = Int32(sessionItems.count)
            nextScene.sessionObj = self.currentSession //Need to ensure the new session is being passed thru
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
