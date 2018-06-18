//
//  SideMenuViewController.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/17.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBAction func signOut(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("goBack"), object: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
