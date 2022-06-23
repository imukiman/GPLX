//
//  RightTableViewCell.swift
//  QuizVer2
//
//  Created by MacOne-YJ4KBJ on 06/06/2022.
//

import UIKit

class RightTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Answer: UILabel!
    @IBOutlet weak var img_Check: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContent.layer.cornerRadius = 10
        viewContent.layer.borderWidth = 0.5
        lbl_Answer.textColor = .txtColorGreen
        img_Check.tintColor = .txtColorGreen
        viewContent.layer.borderColor = UIColor.txtColorGreen.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
