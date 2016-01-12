//
//  AddCommentTableViewCell.swift
//  PubFeed
//
//  Created by Thang H Tong on 1/12/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class AddCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
