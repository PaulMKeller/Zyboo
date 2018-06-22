//
//  SignUpViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 22/6/18.
//  Copyright © 2018 PlanetKGames. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var emailAddress: UITextField!
    @IBAction func signUp(_ sender: Any) {
        self.view.endEditing(true)
        
        if firstName.text == "" || lastName.text == "" || emailAddress.text == "" {
            let alert = UIAlertController(title: "Empty Values", message: "The empire insists all fields must have values...", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.prepareForSegue(segueIdentifier: "signUp")
        }
    }
    
    @IBAction func ignoreSignUp(_ sender: Any) {
        self.prepareForSegue(segueIdentifier: "ignoreSignUp")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    func prepareForSegue(segueIdentifier: String) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        /*
        let nextScene = segue.destination as! UITableViewController
        if segue.identifier == "signUp" {
            /*
            nextScene.currentLatitude = self.latitude
            */
        } else if segue.identifier == "ignoreSignUp" {

        }
        */
    }
    

}
