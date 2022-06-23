//
//  RightCollectionViewCell.swift
//  QuizVer2
//
//  Created by MacOne-YJ4KBJ on 06/06/2022.
//

import UIKit

class RightCollectionViewCell: UICollectionViewCell {
    var numberquetion : Int = 0{
        didSet{
            self.lbl_number_collectionviewcell.text = "Câu " + String(numberquetion)
        }
    }
    @IBOutlet weak var border_select: UIView!
    @IBOutlet weak var lbl_number_collectionviewcell: UILabel!
    @IBOutlet weak var viewContent_collectionviewcell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContent_collectionviewcell.backgroundColor = .bgColorRight
    }

}
