//
//  LectReviewVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit

class CellQuestion: UITableViewCell
{
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
}
class LectReviewVc : UIViewController ,UIWebViewDelegate{
    var selectedIndexOpt0:NSIndexPath?
    var selectedIndexOpt1:NSIndexPath?
    var selectedIndexOpt2:NSIndexPath?
    var selectedIndexOpt3:NSIndexPath?
    var selected0 = ""
    var selected1 = ""
    var selected2 = ""
    var selected3 = ""
    var selectedSection0 = Int()
    var selectedSection1 = Int()
    var selectedSection2 = Int()
    var selectedSection3 = Int()
    
    @IBOutlet weak var webVw: UIWebView!
    var getReview = ""
    var getGroupId1 = ""
    var contentArray : [[String:Any]] = []
    var QuestionArray : [String:Any] = [:]
    var correctanswer : [String] = []
    var dict : [String:Any] = [:]

    @IBOutlet weak var ParentVw: UIView!
    @IBOutlet weak var TblVwContent: UITableView!
    
    @IBOutlet weak var TxtViewContent: UILabel!
    @IBOutlet weak var LblHeadingTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        ParentVw.layer.cornerRadius = 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.postCourseContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func postCourseContent() {
        if let authKey = UserDefaults.standard.value(forKey: "auth_key") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.course_content_listing, jsonString: Request.oneCourseId(authKey, getReview) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                if let dict = sucess["body"] as? [String:Any] {
                    self.dict  = dict
                    let values = self.dict
                    if let allContent = values["course_content"] as? [[String:Any]], allContent.count > 0 {
                        let QuestionsAnswer = allContent[0]
                        if let contentarr = QuestionsAnswer["Questions"] as? [[String:Any]] {
                            self.contentArray = contentarr
                            for i in 0..<2 {
                                let correct = self.contentArray[i]
                                self.correctanswer.append(correct["correct_answer"] as! String)
                            }
                            
                            self.TxtViewContent.text = (QuestionsAnswer["content"] as? String)?.html2String
                            self.TxtViewContent.isHidden = true
                            if let HtmlString = QuestionsAnswer["content"] as? String {
                                self.webVw.loadHTMLString(HtmlString, baseURL: nil)
                            }
                            self.LblHeadingTitle.text = (QuestionsAnswer["chapter_name"] as? String ?? "") + " Part 1"
                        }
                    }
                    self.TblVwContent.reloadData()
                }
                
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func PostCourseCompleted() {
        if let authKey = UserDefaults.standard.value(forKey: "auth_key") as? String {
            DataManager.postAPIWithParameters(urlString: API.completedCourse, jsonString: Request.oneCourseId(authKey, getReview) as [String : AnyObject], success: {
                sucess in
            }, failure: {
                fail in
            })
        }
    }
  
    @IBAction func ActnSubmitBtn(_ sender: Any) {
        if selectedSection0 == 0 && selectedSection1 == 1  {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LectReviewVc2") as? LectReviewVc2
            vc?.getReview2 = getReview
            self.navigationController?.pushViewController(vc!, animated: true)
           } else {
              self.alert()
        }
    }
    
    func alert() {
        let alert = UIAlertController(title: "MESSAGE", message: "Give Answers", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func popUp() {
        let menuVC : PopUpVc = self.storyboard!.instantiateViewController(withIdentifier: "PopUpVc") as! PopUpVc
        menuVC.completedId = getReview
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        menuVC.view.frame=CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        UIView.animate(withDuration: 0.0, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
    }
    
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
 }

extension LectReviewVc : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentArray.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        label.backgroundColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        let text = contentArray[section]
        if text.index(forKey: "question") == nil {
            label.text = "Question not Available"
        } else {
          label.text = (text["question"] as! String)
        }
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CellQuestion = (tableView.dequeueReusableCell(withIdentifier: "CellQuestion") as? CellQuestion)!
        
        let value = contentArray[indexPath.section]
        cell.itemLabel.text = (value["option" + String(indexPath.row+1)] as? String ?? "")
        cell.radioButton.layer.cornerRadius = cell.radioButton.frame.height/2
        if indexPath.section == 0 {
            if (selectedIndexOpt0 == indexPath as NSIndexPath) {
                cell.radioButton.setImage(#imageLiteral(resourceName: "dot"), for: .normal)
            } else {
                cell.radioButton.setImage(nil, for: .normal)
            }
        }
        else  if indexPath.section == 1 {
            if (selectedIndexOpt1 == indexPath as NSIndexPath) {
                cell.radioButton.setImage(#imageLiteral(resourceName: "dot"), for: .normal)
            } else {
                cell.radioButton.setImage(nil, for: .normal)
            }
        }
//        else  if indexPath.section == 2 {
//            if (selectedIndexOpt2 == indexPath as NSIndexPath) {
//                cell.radioButton.setImage(#imageLiteral(resourceName: "dot"), for: .normal)
//            } else {
//                cell.radioButton.setImage(nil, for: .normal)
//            }
//        }
//        else  if indexPath.section == 3 {
//            if (selectedIndexOpt3 == indexPath as NSIndexPath) {
//                cell.radioButton.setImage(#imageLiteral(resourceName: "dot"), for: .normal)
//            } else {
//                cell.radioButton.setImage(nil, for: .normal)
//            }
//        }
      return cell
  }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedSection0 = indexPath.section
             if correctanswer[0] == String(indexPath.row + 1)
             {
              selected0 = correctanswer[0]
             }
           selectedIndexOpt0 = indexPath as NSIndexPath
        } else if indexPath.section == 1 {
            selectedSection1 = indexPath.section
            if correctanswer[1] == String(indexPath.row + 1)
            {
                selected1 = correctanswer[1]
            }
            selectedIndexOpt1 = indexPath as NSIndexPath
        }
//        else if indexPath.section == 2 {
//            selectedSection2 = indexPath.section
//            if correctanswer[2] == String(indexPath.row + 1)
//            {
//                selected2 = correctanswer[2]
//            }
//            selectedIndexOpt2 = indexPath as NSIndexPath
//        }
//        else if indexPath.section == 3 {
//            selectedSection3 = indexPath.section
//            if correctanswer[3] == String(indexPath.row + 1)
//            {
//                selected3 = correctanswer[3]
//            }
//            selectedIndexOpt3 = indexPath as NSIndexPath
//        }
        tableView.reloadData()
  }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        ActivityIndicator.shared.show(self.view)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        webView.frame.size.height = 1
//        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        ActivityIndicator.shared.hide()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIAlertController.show(self, "Error", "While loading content")
    }
   
}


