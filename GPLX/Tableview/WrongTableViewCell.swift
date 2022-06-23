//
//  WrongTableViewCell.swift
//  QuizVer2
//
//  Created by MacOne-YJ4KBJ on 06/06/2022.
//

import UIKit

class WrongTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Answer: UILabel!
    @IBOutlet weak var img_Check: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContent.layer.borderWidth = 0.5
        viewContent.layer.borderColor = UIColor.red.cgColor
        viewContent.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
