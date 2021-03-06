//
//  SideMenuViewController.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/17.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit


//這個Protocol的代理對象為ContainerVC
protocol UpdateContainerVCContentProtocol {
    func updateContainerVCContent(index:IndexPath)
}

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var sideTableView: UITableView!
    
    //接收前面傳過來的使用者大頭貼URL
    var userAvatarURL:URL?
    
    
    //設定Delegate
    var delegate:UpdateContainerVCContentProtocol?
    
    let tableViewInfoArray = ["個人詳細資訊","登出"]
//    @IBAction func signOut(_ sender: UIButton) {
//        NotificationCenter.default.post(name: Notification.Name("goBack"), object: nil)
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        sideTableView.backgroundColor = .gray
        sideTableView.delegate = self
        sideTableView.dataSource = self
        guard let userAvatarURL = self.userAvatarURL else {return}
        print("接收到使用者大頭貼URL",userAvatarURL)
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: userAvatarURL) else {return}
            DispatchQueue.main.async {
                self.userAvatarImageView.image = UIImage(data: imageData)
            }
        }
        
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIDManager.sideMenuCell, for: indexPath)
        cell.textLabel?.text = tableViewInfoArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //點按Cell要做的事
        delegate?.updateContainerVCContent(index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .gray
        return footerView
    }
}
