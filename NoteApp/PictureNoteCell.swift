//
//  PictureNoteCell.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/24.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit

class PictureNoteCell: UITableViewCell {

    
    @IBOutlet weak var ContentView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
