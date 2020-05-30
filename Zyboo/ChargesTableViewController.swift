//
//  ChargesTableViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 19/10/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class ChargesTableViewController: UITableViewController, TriggerServiceChargeSaveDelegate {

    var chargesObjs = [NSManagedObject]()
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func addTapped(_ sender: Any) {
        prepareForSegue(segueIdentifier: "addNewCharge")
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        if self.tableView!.isEditing {
            self.setEditing(false, animated: true)
            self.editButton.title = "Edit"
            reorderCharges(tableView: tableView)
        } else {
            self.setEditing(true, animated: true)
            self.editButton.title = "Done"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        self.tableView!.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.tableView!.isEditing {
            self.setEditing(false, animated: true)
            self.editButton.title = "Edit"
            reorderCharges(tableView: tableView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view functions

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chargesObjs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingChargeTableViewCell", for: indexPath) as! SettingChargeTableViewCell

        let thisCharge = chargesObjs[indexPath.row] as! ServiceChargeObj
        cell.settingName.text = thisCharge.chargeName
        cell.settingValue.text = String(thisCharge.percentageCharge)
        cell.valueStepper.value = Double(thisCharge.percentageCharge)
        cell.settingApplied.isOn = thisCharge.isOn
        cell.cellDataObj = thisCharge
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //Move the row please...
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            do {
                let currentCharge = chargesObjs[indexPath.row] as! ServiceChargeObj
                managedContext.delete(currentCharge)
                chargesObjs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                try managedContext.save()
                reorderCharges(tableView: tableView)
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
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ServiceChargeObj")
        let sort = NSSortDescriptor(key: "applicationOrder", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            chargesObjs.removeAll()
            chargesObjs = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func triggerServiceChargeSave() {
        saveData()
    }
    
    func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func prepareForSegue(segueIdentifier: String) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewCharge" {
            let nextScene = segue.destination as! NewChargeViewController
            let newCount = Int16(chargesObjs.count + 1)
            nextScene.applicationOrder = newCount
        }
    }
    
    func reorderCharges(tableView: UITableView) {
        for cell in tableView.visibleCells as! [SettingChargeTableViewCell] {
            //do someting with the cell here.
            let indexRow:Int = tableView.indexPath(for: cell)!.row
            let index:Int16 = Int16(indexRow)
            cell.cellDataObj.setValue(index, forKey: "applicationOrder")
        }
        saveData()
    }

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
