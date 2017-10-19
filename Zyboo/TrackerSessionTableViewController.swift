//
//  TrackerSessionTableViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 13/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class TrackerSessionTableViewController: UITableViewController {
    var sessionObjs = [NSManagedObject]()
    var segueSessionObj = NSManagedObject()
    var newSession: Bool = false
    
    @IBAction func addTapped(_ sender: Any) {
        prepareForSessionDetailSegue(segueIdentifier: "newSessionSegue", newSession: true, segueSessionObj: NSManagedObject())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        self.tableView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionObjs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath)

        var thisSession = NSManagedObject()
        thisSession = sessionObjs[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let locationName = thisSession.value(forKey: "locationName") as! String
        let sessionDate = dateFormatter.string(from: thisSession.value(forKey: "sessionDate") as! Date)
        let sessionTotalObj = calculationFunctions()
        
        cell.textLabel?.text = locationName  + " " + sessionTotalObj.calculateRunningTotal(thisSessionObj: thisSession as! SessionObj) + " (" + sessionDate + ")"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        prepareForSessionDetailSegue(segueIdentifier: "sessionDetailSegue", newSession: false, segueSessionObj: sessionObjs[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            do {
                managedContext.delete(sessionObjs[indexPath.row])
                sessionObjs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                try managedContext.save()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func loadData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SessionObj")
        let sort = NSSortDescriptor(key: "sessionDate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            sessionObjs.removeAll()
            sessionObjs = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
    func prepareForSessionDetailSegue(segueIdentifier: String, newSession: Bool, segueSessionObj: NSManagedObject) {
        self.segueSessionObj = segueSessionObj
        self.newSession = newSession
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newSessionSegue" {
            let nextScene = segue.destination as! SessionViewController
            nextScene.newSession = self.newSession
            nextScene.currentSessionObj = self.segueSessionObj
        } else {
            let nextScene = segue.destination as! SessionDetailTableViewController
            nextScene.currentSessionObj = self.segueSessionObj
        }
        
    }
    
    /*
    func passSessionDataBack(session:NSManagedObject) {
        // When the table row is selected, log the index of the row
        // When the object is passed back, replace the object in the sessionsAll 
        //    array with this passed back session using that index value
        
        //self.currentSession = sessionObj
        //self.tableView?.reloadData()
        
        //TODO - LOAD THE TABLE VIEW CHANGES AGAIN WHEN A NEW SESSION IS ADDED
        self.sessionObjs.append(session)
        self.tableView!.reloadData()
    }
    */
}
