//
//  PieceTableViewCell.swift
//  UserInterface
//
//  Created by Daniel Rosario on 4/19/20.
//  Copyright © 2020 Daniel Rosario. All rights reserved.
//

import UIKit

class PieceTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var pieceCellTitle: UILabel!
    
    @IBOutlet weak var pieceCellView: UIView!
    
    @IBOutlet weak var pieceCellImage: UIImageView!
    
}
