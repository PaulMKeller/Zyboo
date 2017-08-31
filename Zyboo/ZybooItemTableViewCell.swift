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
    
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var itemCount: UILabel!
    @IBOutlet var itemStepper: UIStepper!
    @IBAction func stepperTapped(_ sender: UIStepper) {
        itemCount.text = String(Int32(sender.value))
        cellItemObj.itemCount = Int32(sender.value)
        self.delegate?.passItemDataBack(cellZybooItem: cellItemObj)
    }
    var cellItemObj = ZybooItem()
    var cellDataObj = NSManagedObject()
    weak var delegate: ZybooItemTotalPassBackDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
