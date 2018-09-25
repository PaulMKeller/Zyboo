//
//  CalculationFunctions.swift
//  Zyboo
//
//  Created by Paul Keller on 19/10/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class calculationFunctions {
    
    var serviceCharges = [NSManagedObject]()
    var currencies = [NSManagedObject]()
    
    init() {
        loadData()
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
            serviceCharges.removeAll()
            serviceCharges = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let fetchRequestCurrency = NSFetchRequest<NSManagedObject>(entityName: "CurrencyObj")
        let sortCurrency = NSSortDescriptor(key: "currencyName", ascending: true)
        fetchRequestCurrency.sortDescriptors = [sortCurrency]
        do {
            currencies.removeAll()
            currencies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func calculateRunningTotal (thisSessionObj: SessionObj) -> String {
        var runningTotal:Decimal = 0.00
        
        let currentItems = thisSessionObj.zybooItems!
        
        for sessionItem in currentItems {
            let thisItem = sessionItem as! ZybooItemObj
            
            runningTotal = runningTotal + (Decimal(thisItem.itemCount) * Decimal(thisItem.unitCost))
        }
        
        if thisSessionObj.value(forKey: "applyServiceCharge") as! Bool {
            for charge in self.serviceCharges {
                let thisCharge = charge as! ServiceChargeObj
                if thisCharge.isOn {
                    let chargeTotal:Decimal = runningTotal * (Decimal(thisCharge.percentageCharge) / Decimal(100.00))
                    runningTotal = runningTotal + chargeTotal
                }
            }
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        //formatter.numberStyle = NumberFormatter.Style.currency sets everything to pounds
        let formattedAmount = formatter.string(from: runningTotal as NSNumber)!
        return "Total: " + currencySymbolSetting() + String(describing: formattedAmount)
    }
    
    func calculateItemTotal (thisItemObj: ZybooItemObj, applyCharges: Bool) -> String {
        var runningTotal:Decimal = 0.00
        runningTotal = runningTotal + (Decimal(thisItemObj.itemCount) * Decimal(thisItemObj.unitCost))
        
        if applyCharges {
            for charge in self.serviceCharges {
                let thisCharge = charge as! ServiceChargeObj
                if thisCharge.isOn {
                    let chargeTotal:Decimal = runningTotal * (Decimal(thisCharge.percentageCharge) / Decimal(100.00))
                    runningTotal = runningTotal + chargeTotal
                }
            }
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let formattedAmount = formatter.string(from: runningTotal as NSNumber)!
        return currencySymbolSetting() + String(describing: formattedAmount)
        
    }
    
    func currencySymbolSetting() -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return "$"
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequestCurrency = NSFetchRequest<NSManagedObject>(entityName: "CurrencyObj")
        fetchRequestCurrency.predicate = NSPredicate(format: "isOn == true")
        do {
            var selectedCurrency = [NSManagedObject]()
            selectedCurrency.removeAll()
            selectedCurrency = try managedContext.fetch(fetchRequestCurrency)
            if selectedCurrency.count != 0 {
                let thisCurrency = selectedCurrency[0] as! CurrencyObj
                return thisCurrency.currencySymbol!
            } else {
                return "$"
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return "$"
        }
    }
    
    func serviceChargeCount() -> String {
        let charges = serviceCharges as! [ServiceChargeObj]
        var chargeText: String = ""
        for charge in charges {
            if charge.isOn {
                chargeText = chargeText + "+"
            }
        }
        return chargeText
    }
}
