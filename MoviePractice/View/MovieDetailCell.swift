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
    //用一個Bool值來管理這個Cell是否在已評分的狀態下
    var giveRate:Bool = false
    //由於要發送刪除請求這邊需要得到movieID
    var deleteRateMovieID:Int?
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var myRateLabel: UILabel!
    
    @IBOutlet weak var rateButton: UIButton!
    @IBAction func rateAction(_ sender: UIButton) {
        guard let index = index else {return}

        //如果giveRate狀態是true代表已經給評分，此時再點按一次就會變成刪除評分，所以這時發送刪除請求
        if giveRate == true{
            guard let deleteRateMovieID = self.deleteRateMovieID else {return}
            print("刪除\(deleteRateMovieID)評分")
            APIManager.shared.deleteRate(deleteURL: URLManager.postAndDeleteRatingURL + "\(deleteRateMovieID)" + "/rating", queryParameters: ["api_key":URLManager.apiKey,"guest_session_id":UserDefaults.standard.string(forKey: UserDefaultKey.guessSessionID)!], headerParameters: ["Content-Type":"application/json"]) { (responseDic) in
                print("有DELETE成功")
                guard let responseDic = responseDic else {return}
                print(responseDic)
            }
        }
        
        rateDelegate?.postRateForMovie(index: index)
    }
    
    
    func updateUI(model:Movie,giveRatingModel:GiveMovieRatingModel){
        movieTitleLabel.text = model.title
        popularityLabel.text = "\(model.popularity!)"
        releaseDateLabel.text = model.releaseDate
        if giveRatingModel.didRating == true{
            rateButton.backgroundColor = .red
            rateButton.setTitleColor(.white, for: .normal)
            rateButton.tintColor = .white
            myRateLabel.text = "您給\(giveRatingModel.score)分"
        }else{
            rateButton.backgroundColor = .white
            rateButton.setTitleColor(.black, for: .normal)
            myRateLabel.text = "尚未評分"
        }
        //把movieID存到刪除要用的movieID
        self.deleteRateMovieID = model.id
        //把model上的是否已評分存到Cell自己的是否已評分
        self.giveRate = giveRatingModel.didRating
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
