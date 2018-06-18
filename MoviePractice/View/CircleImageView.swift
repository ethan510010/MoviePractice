//
//  CircleImageView.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/18.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
