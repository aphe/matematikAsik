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
    var number:String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        cellNumber.text = number
    }

}
