//
//  MovieDetailCell.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/10.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

protocol POSTRateProtocol{
    func postRateForMovie(index:IndexPath)
}

class MovieDetailCell: UITableViewCell {
    
    var rateDelegate:POSTRateProtocol?
    var index:IndexPath?
    var giveRate:Bool = false
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var myRateLabel: UILabel!
    
    @IBOutlet weak var rateButton: UIButton!
    @IBAction func rateAction(_ sender: UIButton) {
        guard let index = index else {return}
//        giveRate = !giveRate
        rateDelegate?.postRateForMovie(index: index)
    }
    
    
    func updateUI(model:Movie,giveRatingModel:GiveMovieRatingModel){
        movieTitleLabel.text = model.title
        popularityLabel.text = "\(model.popularity!)"
        releaseDateLabel.text = model.releaseDate
        if giveRatingModel.didRating == true{
            rateButton.backgroundColor = .blue
            rateButton.tintColor = .white
            myRateLabel.text = "您給\(giveRatingModel.score)分"
        }else{
            rateButton.backgroundColor = .white
            rateButton.tintColor = .blue
            myRateLabel.text = "尚未評分"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
}
