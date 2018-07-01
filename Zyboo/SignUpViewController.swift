//
//  SignUpViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 22/6/18.
//  Copyright © 2018 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {
    var userObj = NSManagedObject()
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet var nickName: UITextField!
    @IBAction func signUp(_ sender: Any) {
        self.view.endEditing(true)
        
        if firstName.text == "" || lastName.text == "" || emailAddress.text == "" ||  contactNumber.text == "" || nickName.text == "" {
            let alert = UIAlertController(title: "Empty Values", message: "Annoying I know but all fields must have values...", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if (signUpSuccessful()) {
                self.prepareForSegue(segueIdentifier: "signUpSegue")
            } else {
                let alert = UIAlertController(title: "Sign Up Failed", message: "Well this is embarassing, sign up failed, sorry. Tap 'Ignore Sign Up' for now...", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func ignoreSignUp(_ sender: Any) {
        self.prepareForSegue(segueIdentifier: "signUpSegue")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //NEED TO CHECK IF THE USER ALREADY EXISTS
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SignUp
    func signUpSuccessful() -> Bool {
        
        // Get the return from the script
        // Create a user object and save to data area
        
        let url:URL = URL(string: "http://www.gratuityp.com/pk/Zyboo/insertUser.php")!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.cachePolicy = NSURLRequest.CachePolicyNSURLRequest.CachePolicy
        
        var paramString = "firstname=" + self.firstName.text!
        paramString += "&lastname=" + self.lastName.text!
        paramString += "&nickName=" + self.nickName.text!
        paramString += "&telNo=" + self.contactNumber.text!
        paramString += "&emailAddr=" + self.emailAddress.text!
        print(paramString)
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request) {
            (
            data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString!)
            //Do something with the returned data...
            let userID = Int32()
            
            
            //CoreData Section
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entityUserObj = NSEntityDescription.entity(forEntityName: "UserObj", in: managedContext)
            let newUserObj = NSManagedObject(entity: entityUserObj!, insertInto: managedContext)
            
            newUserObj.setValue(self.firstName.text!, forKey: "firstName")
            newUserObj.setValue(self.lastName.text!, forKey: "lastName")
            newUserObj.setValue(self.nickName.text!, forKey: "nickName")
            newUserObj.setValue(self.emailAddress.text!, forKey: "emailAddr")
            newUserObj.setValue(self.contactNumber.text!, forKey: "contactNumber")
            newUserObj.setValue(userID, forKey: "contactNumber")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        task.resume()
        
        return false
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
