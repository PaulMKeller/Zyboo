//
//  SessionDetailTableViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 13/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class SessionDetailTableViewController: UITableViewController, ZybooItemTotalPassBackDelegate {
    
    @IBOutlet weak var sessionNavItem: UINavigationItem!
    var sessionItems = [ZybooItem]()
    var runningTotal: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        sessionItems.removeAll()
        
        let beer = ZybooItem()
        beer.itemName = "Beer"
        beer.itemCount = 0
        beer.itemID = 1
        beer.unitCost = 15.00
        
        sessionItems.append(beer)
        
        let wine = ZybooItem()
        wine.itemName = "Wine"
        wine.itemCount = 0
        wine.itemID = 2
        wine.unitCost = 10.00
        
        sessionItems.append(wine)
        
        let spirits = ZybooItem()
        spirits.itemName = "Spirits"
        spirits.itemCount = 0
        spirits.itemID = 3
        spirits.unitCost = 19.00
        
        sessionItems.append(spirits)
        
        let mixer = ZybooItem()
        mixer.itemName = "Mixer"
        mixer.itemCount = 0
        mixer.itemID = 4
        mixer.unitCost = 5.00
        
        sessionItems.append(mixer)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "zybooItemCell", for: indexPath) as! ZybooItemTableViewCell

        //var sessionItem = ZybooItem()
        //sessionItem = sessionItems[indexPath.row]
        // need to set up a custom cell and set it's values here
        var currentItem = ZybooItem()
        currentItem = sessionItems[indexPath.row]
        cell.cellItemObj = currentItem
        cell.itemDescription.text = currentItem.itemName
        cell.itemCount.text = String(currentItem.itemCount)

        return cell
    }
    
    func passTotalDataBack(startingTotal: Double, newTotal: Double) {
        
        runningTotal = 0.0
        sessionNavItem.title = "Total: $"
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
