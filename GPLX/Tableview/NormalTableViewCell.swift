//
//  NormalTableViewCell.swift
//  QuizVer2
//
//  Created by MacOne-YJ4KBJ on 06/06/2022.
//

import UIKit

class NormalTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Answer: UILabel!
    @IBOutlet weak var img_Check: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContent.layer.cornerRadius = 10// Initialization code
        viewContent.layer.borderWidth = 0.5
        viewContent.layer.borderColor = UIColor.clear.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            lbl_Answer.textColor = .orange
            viewContent.layer.borderWidth = 0.5
            viewContent.layer.borderColor = UIColor.orange.cgColor
            img_Check.image = UIImage(systemName: "checkmark.circle")
            img_Check.tintColor = .orange
        }else{
            resetUI()
        }
        // Configure the view for the selected state
    }
    func resetUI(){
        lbl_Answer.textColor = .darkGray
        viewContent.layer.borderWidth = 0.5
        viewContent.layer.borderColor = UIColor.clear.cgColor
        img_Check.image = UIImage(systemName: "circle")
        img_Check.tintColor = .darkGray
    }
}
