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
    //weak var delegate: ZybooItemTotalPassBackDelegate?
    weak var delegate: TriggerZybooItemSaveDelegate?
    
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var itemCount: UILabel!
    @IBOutlet var itemStepper: UIStepper!
    @IBAction func stepperTapped(_ sender: UIStepper) {
        
        
        let thisZybooItem = cellDataObj as! ZybooItemObj
        thisZybooItem.itemCount = Int32(sender.value)
        //thisRunningTotal.text = thisZybooItem.unitCost * Int32(sender.value)
        
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
