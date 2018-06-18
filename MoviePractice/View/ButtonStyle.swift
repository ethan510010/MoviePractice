//
//  ButtonStyle.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/13.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class CornerButton: UIButton{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5).cgColor
        self.layer.borderWidth = 1
    }
}
