//
//  ContainerViewController.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/17.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    var sideMenuOpen:Bool = false
    var userAvatarURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userAvatarURL != nil{
            print(userAvatarURL!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: .toggleSideMunu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signOut), name: .goBack, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func signOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenuConstraint.constant = -200
            self.view.layoutIfNeeded()
        }) { (result) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func toggleSideMenu(){
        if sideMenuOpen{
            sideMenuOpen = false
            sideMenuConstraint.constant = -200
        }else{
            sideMenuOpen = true
            sideMenuConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIDManager.sideMenuSegue{
            guard let sideMenuVC = segue.destination as? SideMenuViewController else {return}
            guard let userAvatarURL = self.userAvatarURL else {return}
            sideMenuVC.userAvatarURL = userAvatarURL
        }
    }

}
