//
//  ZybooItemTableViewCell.swift
//  Zyboo
//
//  Created by Paul Keller on 15/07/2017.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class ZybooItemTableViewCell: UITableViewCell {
    
    var cellDataObj = NSManagedObject()
    weak var delegate: TriggerZybooItemSaveDelegate?
    var applyCharges: Bool?
    var calc = calculationFunctions()
    
    @IBOutlet weak var itemTotal: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var itemCount: UILabel!
    @IBOutlet var itemStepper: UIStepper!
    @IBAction func stepperTapped(_ sender: UIStepper) {
        
        
        let thisZybooItem = cellDataObj as! ZybooItemObj
        thisZybooItem.itemCount = Int32(sender.value)
        
        //itemTotal.text = String(thisZybooItem.unitCost * Double(sender.value))
        itemTotal.text = calc.calculateItemTotal(thisItemObj: thisZybooItem, applyCharges: applyCharges!)
        itemCount.text = String(Int32(sender.value))
        
        self.delegate?.triggerItemSave()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
