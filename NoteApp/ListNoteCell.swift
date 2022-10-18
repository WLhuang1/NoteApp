//
//  ListNoteCell.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/24.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit

class ListNoteCell: UITableViewCell {
    
    @IBOutlet weak var ContentText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
