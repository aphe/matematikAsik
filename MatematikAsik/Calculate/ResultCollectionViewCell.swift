//
//  ResultCollectionViewCell.swift
//  MatematikAsik
//
//  Created by Afriyandi Setiawan on 25/03/19.
//  Copyright © 2019 Afriyandi Setiawan. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.layer.cornerRadius = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellNumber.text = ""
    }

}
