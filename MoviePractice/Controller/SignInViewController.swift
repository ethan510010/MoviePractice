//
//  SignInViewController.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/10.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    var jsonResponseDic:NSDictionary?{
        didSet{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: SegueIDManager.performMovieVC, sender: nil)
            }
        }
    }
    
    @IBAction func guestSignIn(_ sender: UIButton) {
        APIManager.shared.getRequest(url: URLManager.getGuestSessionIDURL, queryParameters: ["api_key":URLManager.apiKey], headerParameters: nil) { (jsonDic) in
            if jsonDic != nil{
                self.jsonResponseDic = jsonDic!
                UserDefaults.standard.set(self.jsonResponseDic!["guest_session_id"]!, forKey: UserDefaultKey.guessSessionID)
            }else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "錯誤", message: "請檢查您的網路狀態", preferredStyle: .alert)
                    let action = UIAlertAction(title: "確定", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
