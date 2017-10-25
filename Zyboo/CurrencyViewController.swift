//
//  CurrencyViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 25/10/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class CurrencyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var currencyObjs = [NSManagedObject]()
    var selectedCurrencyRow:Int = 0
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.currencyPicker.delegate = self
        self.currencyPicker.dataSource = self
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrencyObj")
        let sort = NSSortDescriptor(key: "currencyName", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            currencyObjs.removeAll()
            currencyObjs = try managedContext.fetch(fetchRequest)
            var i:Int = 0
            loopForCurrentObj: for obj in currencyObjs {
                let thisObj = obj as! CurrencyObj
                if thisObj.isOn {
                    selectedCurrencyRow = i
                    self.currencyPicker.selectRow(i, inComponent: 0, animated: true)
                    break loopForCurrentObj
                }
                i = i + 1
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyObjs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let thisCurrency = currencyObjs[row] as! CurrencyObj
        var pickerDisplay: String
        pickerDisplay = thisCurrency.currencyName! + " (" + thisCurrency.currencySymbol! + ")"
        return pickerDisplay
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var i:Int = 0
        for obj in currencyObjs {
            if i == row {
                obj.setValue(true, forKey: "isOn")
            } else {
                obj.setValue(false, forKey: "isOn")
            }
            i = i + 1
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
