//
//  ViewController.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/8.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

enum Condition:Int{
    case 現正上映 = 0
    case 熱門電影
    case 高分電影
    case 將要上映
}

class MovieViewController: UIViewController {
    
    
    var currentPage:Int = 1
    //選擇的movieRow要把它傳過去slider VC
//    var chooseMovieRow:Int?
    
    var defaultBaseMovieURL:String = URLManager.fetchNowPlayingMovies{
        didSet{
            APIManager.shared.fetchMovie(url: defaultBaseMovieURL, queryParameters: ["api_key":URLManager.apiKey,"language":"zh-TW","page":currentPage], headerParameters: nil) { (movies) in
                self.movieArray = movies
            }
        }
    }
    
    //因為後端本身的movieModel沒有自己的評分分數 所以自己在本地端寫一個，把情況分成四種
    var giveMovieRatingArrayForNowPlaying:[GiveMovieRatingModel] = []
    var giveMovieRatingArrayForPopular:[GiveMovieRatingModel] = []
    var giveMovieRatingArrayForTopRated:[GiveMovieRatingModel] = []
    var giveMovieRatingArrayForUpcoming:[GiveMovieRatingModel] = []
    
    var movieArray:[Movie]?{
        didSet{
            DispatchQueue.main.async {
                self.movieDetailTableView.reloadData()
            }
            guard let movieArray = movieArray else {return}
            for _ in 0...movieArray.count{
                switch defaultBaseMovieURL{
                case URLManager.fetchNowPlayingMovies:
                    giveMovieRatingArrayForNowPlaying.append(GiveMovieRatingModel(didRating: false, score: 0))
                case URLManager.fetchPopularMovies:
                    giveMovieRatingArrayForPopular.append(GiveMovieRatingModel(didRating: false, score: 0))
                case URLManager.fetchTopRatedMovies:
                    giveMovieRatingArrayForTopRated.append(GiveMovieRatingModel(didRating: false, score: 0))
                case URLManager.fetchUpcomingMovies:
                    giveMovieRatingArrayForUpcoming.append(GiveMovieRatingModel(didRating: false, score: 0))
                default:
                    break
                }
            }
        }
    }
    
    
   
    
    @IBOutlet weak var movieConditionCollectionView: UICollectionView!
    @IBOutlet weak var movieDetailTableView: UITableView!
    let movieConditionArray = [MovieCondition(movieConditionName: "現正上映", isSelected: true),MovieCondition(movieConditionName: "熱門電影", isSelected: false),MovieCondition(movieConditionName: "高分電影", isSelected: false),MovieCondition(movieConditionName: "將要上映", isSelected: false)]

    override func viewDidLoad() {
        super.viewDidLoad()
        //下面三行是為了reloadData不要跳動
        movieDetailTableView.estimatedRowHeight = 0
        movieDetailTableView.estimatedSectionHeaderHeight = 0
        movieDetailTableView.estimatedSectionFooterHeight = 0
        movieDetailTableView.delegate = self
        movieDetailTableView.dataSource = self
        movieConditionCollectionView.delegate = self
        movieConditionCollectionView.dataSource = self
        APIManager.shared.fetchMovie(url: defaultBaseMovieURL, queryParameters: ["api_key":URLManager.apiKey,"language":"zh-TW","page":currentPage], headerParameters: nil) { (movies) in
            self.movieArray = movies
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueIDManager.performRateSlider else {return}
        guard let rateSliderVC = segue.destination as? SliderViewController else {return}
        rateSliderVC.delegate = self
        guard let sender = sender as? [Int] else { return }
        //第一項為MovieID，第二項為選到的row
        guard let movieID = sender.first else {return}
        rateSliderVC.acceptMovieIDFromTableViewButton = movieID
        //第二項為選到的row
        rateSliderVC.acceptMovieRowFromTableView = sender.last
//        guard let chooseMovieRow = self.chooseMovieRow else {return}
//        print("我在tableView選擇的Row",chooseMovieRow)
//        rateSliderVC.acceptMovieRowFromTableView = chooseMovieRow
    }

}

extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieConditionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieConditionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIDManager.movieConditionCell, for: indexPath) as! MovieConditionCell
        movieConditionCell.updateUI(model: movieConditionArray[indexPath.item])
        return movieConditionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieConditionArray[indexPath.item].isSelected = true
        switch indexPath.item {
        case Condition.現正上映.rawValue:
            self.defaultBaseMovieURL = URLManager.fetchNowPlayingMovies
        case Condition.熱門電影.rawValue:
            self.defaultBaseMovieURL = URLManager.fetchPopularMovies
        case Condition.高分電影.rawValue:
            self.defaultBaseMovieURL = URLManager.fetchTopRatedMovies
        case Condition.將要上映.rawValue:
            self.defaultBaseMovieURL = URLManager.fetchUpcomingMovies
        default:
            break
        }
        movieConditionCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/CGFloat(movieConditionArray.count), height: self.view.frame.height * (60/667))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = self.movieArray?.count else { return 0}
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIDManager.movieDetailCell, for: indexPath) as! MovieDetailCell
        //把TableView的row存到外面的變數
        //處理Delegate
        cell.index = indexPath
        cell.rateDelegate = self
        switch defaultBaseMovieURL {
        case URLManager.fetchNowPlayingMovies:
            cell.updateUI(model: movieArray![indexPath.row], giveRatingModel: giveMovieRatingArrayForNowPlaying[indexPath.row])
        case URLManager.fetchPopularMovies:
            cell.updateUI(model: movieArray![indexPath.row], giveRatingModel: giveMovieRatingArrayForPopular[indexPath.row])
        case URLManager.fetchTopRatedMovies:
            cell.updateUI(model: movieArray![indexPath.row], giveRatingModel: giveMovieRatingArrayForTopRated[indexPath.row])
        default:
            cell.updateUI(model: movieArray![indexPath.row], giveRatingModel: giveMovieRatingArrayForUpcoming[indexPath.row])
        }
        cell.movieImageView.image = nil
        cell.tag = indexPath.row
        guard let posterURL = self.movieArray?[indexPath.row].posterPath else { return UITableViewCell()}
        APIManager.shared.downloadImage(imageURL: URLManager.baseImageURL + posterURL) { (downloadedImage) in
            DispatchQueue.main.async {
                 if indexPath.row == cell.tag{
                    cell.movieImageView.image = downloadedImage
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * (100/667)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let movieArray = self.movieArray else {return}
//        if indexPath.row == movieArray.count - 1{
//                self.currentPage += 1
//                APIManager.shared.fetchMovie(url: defaultBaseMovieURL, queryParameters: ["api_key":URLManager.apiKey,"page":currentPage], headerParameters: nil) { (movies) in
//                    if movies != nil{
//                        self.movieArray = movies
//                    }else{
//                        DispatchQueue.main.async {
//                            let alert = UIAlertController(title: "到底囉", message: "目前僅顯示這麼多", preferredStyle: .alert)
//                            let action = UIAlertAction(title: "確定", style: .default, handler: nil)
//                            alert.addAction(action)
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                }
//        }
//    }
}

//這個是處理Cell上按鈕的點擊事件
extension MovieViewController: POSTRateProtocol{
    func postRateForMovie(index: IndexPath) {
        guard let movies = self.movieArray else {return}
        switch defaultBaseMovieURL {
        case URLManager.fetchNowPlayingMovies:
            giveMovieRatingArrayForNowPlaying[index.row].didRating = !giveMovieRatingArrayForNowPlaying[index.row].didRating
            if giveMovieRatingArrayForNowPlaying[index.row].didRating{
                performSegue(withIdentifier: SegueIDManager.performRateSlider, sender: [movies[index.row].id!,index.row])
            }
        case URLManager.fetchPopularMovies:
            giveMovieRatingArrayForPopular[index.row].didRating = !giveMovieRatingArrayForPopular[index.row].didRating
            if giveMovieRatingArrayForPopular[index.row].didRating{
                performSegue(withIdentifier: SegueIDManager.performRateSlider, sender: [movies[index.row].id!,index.row])
            }
        case URLManager.fetchTopRatedMovies:
            giveMovieRatingArrayForTopRated[index.row].didRating = !giveMovieRatingArrayForTopRated[index.row].didRating
            if giveMovieRatingArrayForTopRated[index.row].didRating{
                performSegue(withIdentifier: SegueIDManager.performRateSlider, sender: [movies[index.row].id!,index.row])
            }
        default:
            giveMovieRatingArrayForUpcoming[index.row].didRating = !giveMovieRatingArrayForUpcoming[index.row].didRating
            if giveMovieRatingArrayForUpcoming[index.row].didRating{
                performSegue(withIdentifier: SegueIDManager.performRateSlider, sender: [movies[index.row].id!,index.row])
            }
        }
        movieDetailTableView.reloadRows(at: [index], with: .none)
    }
}

//這個是接收SliderVC傳回來的分數
extension MovieViewController: PassScoreToMovieVCProtocol{
    func passScoreToMovieVC(score: Float, movieRow: Int) {
        switch defaultBaseMovieURL {
        case URLManager.fetchNowPlayingMovies:
            giveMovieRatingArrayForNowPlaying[movieRow].score = score
        case URLManager.fetchPopularMovies:
            giveMovieRatingArrayForPopular[movieRow].score = score
        case URLManager.fetchTopRatedMovies:
            giveMovieRatingArrayForTopRated[movieRow].score = score
        default:
            giveMovieRatingArrayForUpcoming[movieRow].score = score
        }
        movieDetailTableView.reloadData()
    }
}
