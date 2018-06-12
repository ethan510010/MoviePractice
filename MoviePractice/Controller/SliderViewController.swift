//
//  SliderViewController.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/11.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

protocol PassScoreToMovieVCProtocol {
    func passScoreToMovieVC(score:Float,movieRow:Int)
}

class SliderViewController: UIViewController {
    
    //接收前面過來的TableViewRow數
    var acceptMovieRowFromTableView:Int?
    //接收前面過來的MovieID
    var acceptMovieIDFromTableViewButton:Int?
    //要傳分數到前面的MovieVC
    var delegate:PassScoreToMovieVCProtocol?
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rateSlider: UISlider!
    
    @IBAction func rateSlideAction(_ sender: UISlider) {
        let step:Float = 0.5
        rateSlider.value = roundf(rateSlider.value / step) * step
        scoreLabel.text = "評分:\(rateSlider.value)"
    }
    
    
    @IBAction func ensureAction(_ sender: UIButton) {
        guard let movieRowFromMovieVC = acceptMovieRowFromTableView else { return }
        delegate?.passScoreToMovieVC(score: rateSlider.value, movieRow: movieRowFromMovieVC)
        guard let movieIDFromMovieVC = acceptMovieIDFromTableViewButton else { return }
        //發出POST請求
        APIManager.shared.postRate(postURL: URLManager.postRatingURL + "\(movieIDFromMovieVC)" + "/rating", queryParameter: ["api_key":URLManager.apiKey, "guest_session_id":UserDefaults.standard.string(forKey: UserDefaultKey.guessSessionID)!], bodyParameters: ["value":rateSlider.value], headerParameter: nil) { (responseJSON) in
            if responseJSON != nil{
                print("有POST成功")
                print(responseJSON!)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("得到Row",acceptMovieRowFromTableView!)
        scoreLabel.text = "評分:5.0"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
