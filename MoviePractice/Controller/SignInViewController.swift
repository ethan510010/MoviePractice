//
//  SignInViewController.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/10.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var googleSigninButton:GIDSignInButton!
    
    var jsonResponseDic:NSDictionary?{
        didSet{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: SegueIDManager.performMovieVC, sender: nil)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print(error!.localizedDescription)
            return
        }
        print(user.userID)
        print(user.profile.email)
        print(user.profile.imageURL(withDimension: 300))
        performSegue(withIdentifier: SegueIDManager.performMovieVC, sender: nil)
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
        
        //建立google登入按鈕
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        googleSigninButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        view.addSubview(googleSigninButton)
        googleSigninButton.style = .wide
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        googleSigninButton.center = view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
