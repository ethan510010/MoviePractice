//
//  GiveMovieRatingModel.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/11.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import Foundation

class GiveMovieRatingModel{
    var didRating:Bool
    var score:Float
    init(didRating:Bool,score:Float) {
        self.didRating = didRating
        self.score = score
    }
}
