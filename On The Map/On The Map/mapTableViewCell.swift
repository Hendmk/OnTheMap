//
//  mapTableViewCell.swift
//  On The Map
//
//  Created by Hend Alkabani on 29/01/2019.
//  Copyright © 2019 Hend Alkabani. All rights reserved.
//

import UIKit

class mapTableViewCell: UITableViewCell {

    @IBOutlet weak var studentName: UILabel!

    
    func updateCell(_ fName: String, _ lName: String) {
        studentName.text = "\(fName) \(lName)"
    }

}
