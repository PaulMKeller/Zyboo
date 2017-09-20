//
//  SessionItemViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 30/8/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class SessionItemViewController: UIViewController {

    var currentSession = Session()
    var currentSessionObj = NSManagedObject()
    
    
    @IBOutlet weak var sessionItemNameText: UITextField!
    @IBOutlet weak var sessionItemCost: UITextField!
    @IBAction func costStepper(_ sender: UIStepper) {
        sessionItemCost.text = String(sender.value)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        /*
         Loop each Zyboo Item
         Match is it to a currentSession SessionItem
         Match that to a currentSessionObj item
         Set the values of both
         
         save the new sessionItem if it is new or update it if it is existing.
         
         Pass it back to the previous view
         */
        
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
