//
//  MovieConditionCell.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/9.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class MovieConditionCell: UICollectionViewCell {
    
    @IBOutlet weak var movieConditionLabel: UILabel!
    
    func updateUI(model:MovieCondition){
        
        movieConditionLabel.text = model.movieConditionName
        
        if model.isSelected {
            self.layer.cornerRadius = 8
            self.layer.borderWidth = 3
            self.layer.masksToBounds = true
            self.layer.borderColor = UIColor.white.cgColor
            //            didSelectBarView.backgroundColor = .blue
            model.isSelected = false
        }else{
            self.layer.borderColor = UIColor.clear.cgColor
            //            didSelectBarView.backgroundColor = .clear
        }
    }
    
}
