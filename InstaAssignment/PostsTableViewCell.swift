//
//  PostsTableViewCell.swift
//  InstaAssignment
//
//  Created by Pallav Trivedi on 19/07/17.
//  Copyright © 2017 Pallav Trivedi. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var captionTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
