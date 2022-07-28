//
//  InfoCell.swift
//  Lex
//
//  Created by ChawTech Solutions on 08/03/22.
//

import UIKit
import SkyFloatingLabelTextField

class TextCell: UITableViewCell {

    @IBOutlet weak var textFeild: SkyFloatingLabelTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
