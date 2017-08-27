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
    
    
    var sessionObjs = [NSManagedObject]()
    var sessionsAll = [Session]()
    
    var zybooItemObjs = [NSManagedObject]()
    var zybooItems = [ZybooItem]()
    
    var segueSession = Session()
    var segueSessionObj = NSManagedObject()
    var newSession: Bool = false
    
    @IBAction func addTapped(_ sender: Any) {
        let newSession = Session()
        newSession.sessionItems = zybooItems
        prepareForSessionDetailSegue(segueIdentifier: "sessionDetailSegue", currentSession: newSession, newSession: true)
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
        return sessionsAll.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath)

        var thisSession = Session()
        thisSession = sessionsAll[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        cell.textLabel?.text = thisSession.locationName + " (" + String(describing: dateFormatter.string(from: thisSession.sessionDate)) + ")"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        prepareForSessionDetailSegue(segueIdentifier: "sessionDetailSegue", currentSession: sessionsAll[indexPath.row], newSession: false)
    }
    
    func loadData(){
        
        if zybooItems.count == 0 {
            createZybooItemsArray()
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SessionObj")
        do {
            sessionObjs = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if sessionObjs.count != 0 {
            sessionsAll.removeAll()
            
            for thisSession in sessionObjs {
                let loadingSession = Session()
                loadingSession.locationName = thisSession.value(forKey: "locationName") as! String
                loadingSession.locationLongitude = thisSession.value(forKey: "locationLongitude") as! Double
                loadingSession.locationLatitude = thisSession.value(forKey: "locationLatitude") as! Double
                loadingSession.sessionDate = thisSession.value(forKey: "sessionDate") as! Date
                loadingSession.sessionTotal = thisSession.value(forKey: "sessionTotal") as! Double
                loadingSession.sessionItems = thisSession.value(forKey: "sessionItems") as! [ZybooItem]
                sessionsAll.append(loadingSession)
            }
        }
    }
    
    func passSessionDataBack(sessionObj: Session) {
        // When the table row is selected, log the index of the row
        // When the object is passed back, replace the object in the sessionsAll 
        //    array with this passed back session using that index value
        
        //self.currentSession = sessionObj
        //self.tableView?.reloadData()
    }
    
    func prepareForSessionDetailSegue(segueIdentifier: String, currentSession: Session, newSession: Bool) {
        self.segueSession = currentSession
        //self.segueSessionObj = self.sessionObjs[managedObjIndex] // I have to pass the NSManagedObject through but I don't know how yet
        self.newSession = newSession
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScene = segue.destination as! SessionViewController
        nextScene.newSession = self.newSession
        nextScene.currentSession = self.segueSession
        //nextScene.currentSessionObj = self.segueSessionObj
    }
    
    func createZybooItemsArray(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ZybooItemObj")
        do {
            zybooItemObjs = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        if zybooItemObjs.count == 0 {
            saveZybooItem(itemName: "Beer", itemCount: 0, unitCost: 1.00)
            saveZybooItem(itemName: "Wine", itemCount: 0, unitCost: 2.00)
            saveZybooItem(itemName: "Spirits", itemCount: 0, unitCost: 3.00)
            saveZybooItem(itemName: "Mixer", itemCount: 0, unitCost: 4.00)
            saveZybooItem(itemName: "Small Food", itemCount: 0, unitCost: 5.00)
            saveZybooItem(itemName: "Medium Food", itemCount: 0, unitCost: 6.00)
            saveZybooItem(itemName: "Large Food", itemCount: 0, unitCost: 7.00)
        }
        
        zybooItems.removeAll()
        
        for item in zybooItemObjs {
            let thisItem = ZybooItem()
            thisItem.itemName = item.value(forKey: "itemName") as! String
            thisItem.itemCount = item.value(forKey: "itemCount") as! Int32
            thisItem.unitCost = item.value(forKey: "unitCost") as! Double
            
            zybooItems.append(thisItem)
        }
        
    }
    
    func saveZybooItem(itemName: String, itemCount: Int32, unitCost: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ZybooItemObj",
                                                in: managedContext)!
        
        let newZybooItem = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        newZybooItem.setValue(itemName, forKeyPath: "itemName")
        newZybooItem.setValue(itemCount, forKeyPath: "itemCount")
        newZybooItem.setValue(unitCost, forKeyPath: "unitCost")
        zybooItemObjs.append(newZybooItem)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
