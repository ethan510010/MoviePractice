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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: .toggleSideMunu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signOut), name: Notification.Name("goBack"), object: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
