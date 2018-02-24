//
//  ZybooSessionTableViewCell.swift
//  Zyboo
//
//  Created by Paul Keller on 24/02/2018.
//  Copyright © 2018 PlanetKGames. All rights reserved.
//

import UIKit
import CoreData

class ZybooSessionTableViewCell: UITableViewCell {

    var cellSessionObj = NSManagedObject()
    weak var infoDelegate: TriggerSessionInfoShowDelegate?
    weak var detailDelegate: TriggerSessionDetailShowDelegate?
    
    @IBOutlet var sessionName: UILabel!
    @IBOutlet var sessionDate: UILabel!
    @IBOutlet var sessionTotal: UILabel!
    @IBAction func infoTapped(_ sender: Any) {
        self.infoDelegate?.triggerSessionInfoShow(cellSessionObj: self.cellSessionObj)
    }
    @IBAction func detailsTapped(_ sender: Any) {
        self.detailDelegate?.triggerSessionDetailShow(cellSessionObj: self.cellSessionObj)
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
