//
//  MovieCondition.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/8.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import Foundation

class MovieCondition{
    var  movieConditionName:String
    var  isSelected:Bool
    init(movieConditionName:String,isSelected:Bool) {
        self.movieConditionName = movieConditionName
        self.isSelected = isSelected
    }
}
