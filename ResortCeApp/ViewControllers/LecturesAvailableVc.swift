//
//  LecturesAvailableVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 12/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CollCellLectType: UICollectionViewCell
{
    @IBOutlet weak var LblName: UILabel!
    @IBOutlet weak var LineSelected: UILabel!
}
class CollCell: UICollectionViewCell
{
    @IBOutlet weak var ImgVwLects: UIImageView!
    @IBOutlet weak var TxtLectsOverView: UITextView!
}
//class ReuseView: UICollectionReusableView {
//
//    @IBOutlet weak var label: UILabel!
//}
class LecturesAvailableVc: UIViewController {
    @IBOutlet weak var CollVwLects: UICollectionView!
    @IBOutlet weak var CollVwLectType: UICollectionView!
    var postGroupId = ""
    var PostCourseId = ""
    var getGroupId = ""
    var selectedIndex:Int = 0
    var TypeArray : [[String:Any]] = []
    var nameArray : [[String:Any]] = []
    var SubCategoryId = ""
    var GethotelDict : [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(GethotelDict)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden  = true
        self.PostsubCategoryist()
        self.postOneGroup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ActnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func postOneGroup(){ //list of all courses in one group
        if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.oneGroupList, jsonString: Request.OneGroupList(authKey, getGroupId) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                let Body = sucess["body"] as? [String:Any]
                if let Group = Body?["Group"] as? [String : Any] {
                    if Group.index(forKey: "course") == nil {
                        print("nil")
                    } else {
                        if let nameArr = Group["course"] as? [[String : Any]] {
                            self.nameArray = nameArr
                        }
                    }
                }
                self.CollVwLects.reloadData()
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func PostsubCategoryist() { //list of type of courses in one group
        if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.subcategory_listing, jsonString: Request.setauthKey(authKey) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                print(sucess)
                if let typeArr = sucess["body"] as? [[String:Any]] {
                    self.TypeArray = typeArr
                }
                self.CollVwLectType.reloadData()
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func PostsubCategoryCourse() { //list of all courses under one type
         if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.subcategory_course_listing, jsonString: Request.SubCategoryCourseListing(authKey, SubCategoryId) as [String : AnyObject] , success: {
                sucess in
                ActivityIndicator.shared.hide()
                print(sucess)
                if let nameArr = sucess["body"] as? [[String : Any]] {
                    self.nameArray = nameArr
                }
                self.CollVwLects.reloadData()
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
}
extension LecturesAvailableVc : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CollVwLects {
            return nameArray.count
        }
        return TypeArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CollVwLectType {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollCellLectType", for: indexPath) as! CollCellLectType
            if indexPath.row == selectedIndex {
            cell.LineSelected.isHidden = false
            } else {
                cell.LineSelected.isHidden = true
            }
            if indexPath.item == 0 {
                cell.LblName.text = "All Available Lectures"
            } else {
              let values = TypeArray[(indexPath.item)-1]
              cell.LblName.text = (values["name"] as! String)
            }
            return cell
        }
            let values = nameArray[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollCell", for: indexPath) as! CollCell
            cell.TxtLectsOverView.text = values["name"] as? String
            let photo = values["image"] as? String
            if (photo != "") {
                cell.ImgVwLects.sd_setImage(with: URL(string: photo!), placeholderImage: UIImage(named: "Bed"))
            }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CollVwLects {
            return CGSize(width: (collectionView.frame.width/2)-5, height: 200)
        }
            return CGSize(width: (collectionView.frame.width/3), height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CollVwLects {
            let values = nameArray[indexPath.item]
            PostCourseId = values["id"] as! String
            let vc = storyboard?.instantiateViewController(withIdentifier: "AvailableLectVc") as? AvailableLectVc
            vc?.DatahotelDict = GethotelDict
            vc?.getGroupId = getGroupId
            vc?.detail = PostCourseId
            vc?.shouldShowBuyBtn = false
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        if collectionView == CollVwLectType {
            selectedIndex = indexPath.item
            if indexPath.item == 0 {
                self.postOneGroup()
            } else {
            let values = TypeArray[(indexPath.item)-1]
            SubCategoryId = values["id"] as! String
            self.PostsubCategoryCourse()
            }
           CollVwLectType.reloadData()
        }
    }
}
