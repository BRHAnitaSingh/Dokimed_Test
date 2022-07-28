//
//  QuestionCell.swift
//  Lex
//
//  Created by ChawTech Solutions on 08/03/22.
//

import UIKit
import DLRadioButton

class QuestionCell: UITableViewCell {

    @IBOutlet weak var noLbl: DLRadioButton!
    @IBOutlet weak var yesLbl: DLRadioButton!
    @IBOutlet weak var quesLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
