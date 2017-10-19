//
//  SettingChargeTableViewCell.swift
//  Zyboo
//
//  Created by Paul Keller on 19/10/2017.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class SettingChargeTableViewCell: UITableViewCell {

    var cellDataObj = NSManagedObject()
    weak var delegate: TriggerServiceChargeSaveDelegate?
    
    @IBOutlet var settingName: UILabel!
    @IBOutlet var settingValue: UILabel!
    @IBOutlet var valueStepper: UIStepper!
    @IBOutlet var settingApplied: UISwitch!
    @IBAction func valueChanged(_ sender: UIStepper) {
        settingValue.text = String(Int32(sender.value))
        let thisServiceChargeObj = cellDataObj as! ServiceChargeObj
        thisServiceChargeObj.percentageCharge = Int16(sender.value)
        self.delegate?.triggerServiceChargeSave()
    }
    @IBAction func isOnChanged(_ sender: UISwitch) {
        let thisServiceChargeObj = cellDataObj as! ServiceChargeObj
        thisServiceChargeObj.isOn = sender.isOn
        self.delegate?.triggerServiceChargeSave()
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
