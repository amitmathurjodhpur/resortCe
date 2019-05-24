//
//  LecturesInProgressVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellCollVw : UICollectionViewCell
{
    
    @IBOutlet weak var PlayBtn: UIImageView!
    @IBOutlet weak var imageLect: UIImageView!
    @IBOutlet weak var LectDetail: UITextView!
}


class LecturesInProgressVc: UIViewController {
    var nameArray : [[String:Any]] = []
    var DatahotelDict : [String:Any] = [:]
    var PostLectId = ""
    @IBOutlet weak var collVw: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.title = "Resortcee"
        self.postLectInProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden  = false
    }
    func postLectInProgress() {
        if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
          
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.course_in_progress_listing
                , jsonString: Request.setauthKey(authKey) as [String : AnyObject], success: {
                    sucess in
                    ActivityIndicator.shared.hide()
                    if let nameArr = sucess["body"] as? [[String:Any]] {
                        self.nameArray  = nameArr
                        self.collVw.reloadData()
                    }
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

}
extension LecturesInProgressVc : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollVw", for: indexPath) as? CellCollVw {
            let values = nameArray[indexPath.row]
            cell.LectDetail.text = values["name"] as? String
            let photo = values["image"] as? String
            if (photo != ""){
                cell.imageLect.sd_setImage(with: URL(string: photo!), placeholderImage: UIImage(named:"Bed"))
            }
            return cell
        }
       return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2)-5, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
         let values = nameArray[indexPath.row]
        if let lectId = values["id"] as? String {
            let vc = storyboard?.instantiateViewController(withIdentifier: "AvailableLectVc") as? AvailableLectVc
            vc?.detail = lectId
            vc?.DatahotelDict = DatahotelDict
            vc?.shouldShowBuyBtn = true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

