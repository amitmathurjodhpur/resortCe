//
//  HomeVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 12/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellHome: UITableViewCell
{
    @IBOutlet weak var LblDetailsType: UILabel!
    @IBOutlet weak var ImgVwIcon: UIImageView!
}
class HomeVc: UIViewController {
    var MenuArray : [String] = ["Find Lectures","Lectures In Progress","Locker"]
    var imageArray : [UIImage] = [#imageLiteral(resourceName: "FindLecturesIcon"),#imageLiteral(resourceName: "LectProgIcon"),#imageLiteral(resourceName: "LockerIcon")]
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if   UserDefaults.standard.value(forKey: "First") as! String == "1"
          {
            let alert = UIAlertController(title: "MESSAGE", message: "COMPLETE PROFILE FIRST", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:OkAction))
            self.present(alert, animated: true, completion: nil)
         }
    }
       func OkAction(action: UIAlertAction)
        {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileVc") as? EditProfileVc
        self.navigationController?.pushViewController(vc!, animated: true)
        }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    @IBAction func ActnMenuOpen(_ sender: Any)
    {
        let menuVC : HomeMenuVc = self.storyboard!.instantiateViewController(withIdentifier: "HomeMenuVc") as! HomeMenuVc
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
    }
    
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
extension HomeVc : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MenuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellHome") as? CellHome
        cell?.ImgVwIcon.image = imageArray[indexPath.row]
        cell?.LblDetailsType.text = MenuArray[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "FindLocationVc") as? FindLocationVc
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        if indexPath.row == 1
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LecturesInProgressVc") as? LecturesInProgressVc
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        if indexPath.row == 2
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LockerVc") as? LockerVc
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
