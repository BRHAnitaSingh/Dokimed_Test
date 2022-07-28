//
//  ReportCell.swift
//  Lex
//
//  Created by Ritesh Sinha on 25/03/22.
//

import UIKit

class ReportCell: UITableViewCell {

    @IBOutlet weak var cellCheckboxBtn: UIButton!
    @IBOutlet weak var cellMainLbl: UILabel!
    @IBOutlet weak var cellDateLbl: UILabel!
    @IBOutlet weak var openLinkButton: UIButton!{
        didSet{
            openLinkButton.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var whatAgeLabel: UILabel!
    @IBOutlet weak var howOftenLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
