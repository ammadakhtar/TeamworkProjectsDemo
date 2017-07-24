//
//  ActivityCell.swift
//  TestingTeam
//
//  Created by Ammad on 23/07/2017.
//  Copyright © 2017 Ammad. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var projDescription: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var addedBy: UILabel!
    @IBOutlet weak var projOwner: RoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
