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
    
    var segueSession = Session()
    var segueSessionObj = NSManagedObject()
    var newSession: Bool = false
    
    @IBAction func addTapped(_ sender: Any) {
        let newSession = Session()
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
        return sessionsAll.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath)

        var thisSession = Session()
        thisSession = sessionsAll[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        cell.textLabel?.text = thisSession.locationName + " (" + String(describing: dateFormatter.string(from: thisSession.sessionDate)) + ")"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueSessionObj = sessionObjs[indexPath.row]
        prepareForSessionDetailSegue(segueIdentifier: "sessionDetailSegue", currentSession: sessionsAll[indexPath.row], newSession: false)
    }
    
    func loadData(){
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
        
        //TODO - LOAD THE TABLE VIEW CHANGES AGAIN WHEN A NEW SESSION IS ADDED
    }
    
    func prepareForSessionDetailSegue(segueIdentifier: String, currentSession: Session, newSession: Bool) {
        self.segueSession = currentSession
        //I have to be able to pass through the current session object.
        //THIS IS THE NEXT IMMEDIATE TASK
        self.segueSessionObj = self.sessionObjs[managedObjIndex] // I have to pass the NSManagedObject through but I don't know how yet
        self.newSession = newSession
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScene = segue.destination as! SessionViewController
        nextScene.newSession = self.newSession
        nextScene.currentSession = self.segueSession
        nextScene.currentSessionObj = self.segueSessionObj
    }
}
