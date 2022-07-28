//
//  CalendarCell.swift
//  Lex
//
//  Created by ChawTech Solutions on 06/07/22.
//

import UIKit

class CalendarCell: UITableViewCell {

    @IBOutlet weak var cellMainLbl: UILabel!
    @IBOutlet weak var cellDescLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
