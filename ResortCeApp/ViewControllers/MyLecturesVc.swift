//
//  MyLecturesVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellMylecture: UICollectionViewCell
{
    @IBOutlet weak var LblPrice: UILabel!
    @IBOutlet weak var LblName: UILabel!
    @IBOutlet weak var ImgVw: UIImageView!
    @IBOutlet weak var LblCategory: UILabel!
}
class ReuseableViewMyLect: UICollectionReusableView
{
    @IBOutlet weak var label: UILabel!
}
class MyLecturesVc: UIViewController {
    @IBOutlet weak var CollVwMyLect: UICollectionView!
    var nameArray : [[String:Any]] = []
     var PostLectId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       self.postMyLectures()
    }
    
    func postMyLectures() {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.my_course_listing , jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
           ActivityIndicator.shared.hide()
           self.nameArray = (sucess["body"] as? [[String:Any]])!
            self.CollVwMyLect.reloadData()
            
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
   
}
extension MyLecturesVc : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return nameArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellMylecture", for: indexPath) as? CellMylecture
        let values = nameArray[indexPath.row]
        cell?.LblName.text = values["course_name"] as? String
        cell?.LblPrice.text = values["course_fee"] as? String
        cell?.LblCategory.text = values["category_name"] as? String
        let photo = values["course_image"] as? String
        if (photo != ""){
            cell?.ImgVw.sd_setImage(with: URL(string: photo!), placeholderImage: UIImage(named: "Bed"))
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.width/2)-5, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReuseableViewMyLect", for: indexPath) as! ReuseableViewMyLect
        if nameArray.count > 0
        {
           header.label.text = "Newl and Noteworthy"
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let values = nameArray[indexPath.row]
        PostLectId = values["course_id"] as! String
        let vc = storyboard?.instantiateViewController(withIdentifier: "AvailableLectVc") as? AvailableLectVc
        vc?.detail = PostLectId
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
