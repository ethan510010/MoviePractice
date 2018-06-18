//
//  ContainerViewController.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/17.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore

enum SideMenuCellName:Int {
    case 個人資訊 = 0
    case 登出
}

class ContainerViewController: UIViewController {

    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    
    //下面兩個ViewController是為了Delegate(UpdateContainerVCContentProtocol)的方法觸發
    var movieListVC:MovieViewController!
    var userDetailVC:UserInfoViewController!
    
    //記錄現在在哪一頁
    var selectedViewController:UIViewController!
    
    var sideMenuOpen:Bool = false
    var userAvatarURL:URL?
    
    func changeContainerVCContent(to newVC: UINavigationController){
        //移除 Controller 前要先呼叫 willMove() 讓 Contrller 執行離開頁面的程式 然後使用 removeFromSuperview() 將 Controller 移出 Container View 最後使用 removeFromParentViewController 將 Contrller 移出主頁的 Controller
        selectedViewController.willMove(toParentViewController: nil)
        selectedViewController.view.removeFromSuperview()
        selectedViewController.removeFromParentViewController()
        // 先用 addChildViewController() 將新的 Controller 加進主頁的 Controller 接著將新的 Controller 加進 Container View 設定新 Controller 中頁面的尺寸為 Container View 的大小 呼叫 didMove() 讓新的 Controller 執行頁面載入的程式
        addChildViewController(newVC)
        self.mainContainerView.addSubview(newVC.view)
        newVC.view.frame = mainContainerView.bounds
        newVC.didMove(toParentViewController: self)
        //修改目前選取的頁面為新的 Controller
        self.selectedViewController = newVC
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if userAvatarURL != nil{
            print(userAvatarURL!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: .toggleSideMunu, object: nil)
        
        selectedViewController = movieListVC
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            sideMenuVC.delegate = self
            guard let userAvatarURL = self.userAvatarURL else {return}
            sideMenuVC.userAvatarURL = userAvatarURL
        }
    }

}

extension ContainerViewController: UpdateContainerVCContentProtocol{
    
    func updateContainerVCContent(index: IndexPath) {
        switch index.row {
        case SideMenuCellName.個人資訊.rawValue:
            let userInfoNav = UINavigationController()
            let userInfoVC: UserInfoViewController =
            {UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardIDManager.userDetailVC) as! UserInfoViewController}()
            userInfoNav.addChildViewController(userInfoVC)
            changeContainerVCContent(to: userInfoNav)
        case SideMenuCellName.登出.rawValue:
            //一般來說登出會跟後端溝通好紀錄現在是哪種登入 而配合哪種登出 但現在因為沒有後端 所以先一次性兩個都登出
            GIDSignIn.sharedInstance().signOut()
            LoginManager().logOut()
            UIView.animate(withDuration: 0.3, animations: {
                self.sideMenuConstraint.constant = -200
                self.view.layoutIfNeeded()
            }) { (result) in
                self.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

