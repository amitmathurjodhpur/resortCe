//
//  SecondVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 08/05/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellSecondPage: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
}

class SecondVc: UIViewController ,UIWebViewDelegate {
        var selectedIndexOpt0:NSIndexPath?
        var selectedIndexOpt1:NSIndexPath?
        var selected0 = ""
        var selected1 = ""
        var selectedSection0 = Int()
        var selectedSection1 = Int()
        var getReview2 = ""
        var getGroupId2 = ""
        var contentArray : [[String:Any]] = []
        var QuestionArray : [String:Any] = [:]
        var correctanswer : [String] = []
        var dict : [String:Any] = [:]
        
        @IBOutlet weak var ParentVw: UIView!
        @IBOutlet weak var TblVwContent: UITableView!
        @IBOutlet weak var webVw: UIWebView!
        @IBOutlet weak var TxtViewContent: UILabel!
      
        override func viewDidLoad() {
            super.viewDidLoad()
            automaticallyAdjustsScrollViewInsets = false
            ParentVw.layer.cornerRadius = 3
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
             self.navigationController?.isNavigationBarHidden  = true
            self.postCourseContent()
        }
    
        override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        func postCourseContent() {
            if let authKey = UserDefaults.standard.value(forKey: "auth_key") as? String {
                ActivityIndicator.shared.show(self.view)
                DataManager.postAPIWithParameters(urlString: API.course_content_listing, jsonString: Request.oneCourseId(authKey, getReview2) as [String : AnyObject], success: {
                    sucess in
                    ActivityIndicator.shared.hide()
                    if let dict = sucess["body"] as? [String:Any] {
                        self.dict  = dict
                    }
                    
                    let values = self.dict
                    if let allContent = values["course_content"] as? [[String:Any]], allContent.indices.contains(1) {
                        let QuestionsAnswer = allContent[1]
                        if let contents = QuestionsAnswer["Questions"] as? [[String:Any]] {
                            self.contentArray = contents
                        }
                        
                        for i in 0..<2 {
                            let correct = self.contentArray[i]
                            self.correctanswer.append(correct["correct_answer"] as! String)
                        }
                        self.TxtViewContent.text = (QuestionsAnswer["content"] as? String)?.html2String
                        self.TxtViewContent.isHidden = true
                        if let HtmlString = QuestionsAnswer["content"] as? String {
                            self.webVw.loadHTMLString(HtmlString, baseURL: nil)
                        }
                        self.TblVwContent.reloadData()
                    }
                    
                }, failure: {
                    fail in
                    ActivityIndicator.shared.hide()
                })
            }
        }
    
        @IBAction func ActnSubmitBtn(_ sender: Any) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "thirdVc") as? thirdVc
            vc?.getReview3 = getReview2
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    
        @IBAction func ActnBack(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    extension SecondVc : UITableViewDelegate,UITableViewDataSource {
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
                label.text = (text["question"] as? String ?? "")
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
            let cell : CellSecondPage = (tableView.dequeueReusableCell(withIdentifier: "CellSecondPage") as? CellSecondPage)!
            
            let value = contentArray[indexPath.section]
            cell.itemLabel.text = (value["option" + String(indexPath.row+1)] as? String ?? "")
            cell.radioButton.layer.cornerRadius = cell.radioButton.frame.height/2
            
            if indexPath.section == 0 {
                if correctanswer[0] == String(indexPath.row + 1) {
                    cell.radioButton.backgroundColor = UIColor.green
                } else {
                    cell.radioButton.backgroundColor = UIColor.gray
                }
            } else  if indexPath.section == 1 {
                if correctanswer[1] == String(indexPath.row + 1) {
                    cell.radioButton.backgroundColor = UIColor.green
                } else {
                    cell.radioButton.backgroundColor = UIColor.gray
                }
            }
            return cell
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


