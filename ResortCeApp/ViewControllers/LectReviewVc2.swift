//
//  LectReviewVc2.swift
//  ResortCeApp
//
//  Created by AJ12 on 22/03/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellQuestion2: UITableViewCell
{
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    
}

class LectReviewVc2: UIViewController,UIWebViewDelegate {

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
        @IBOutlet weak var LblHeadingTitle: UILabel!
         @IBOutlet weak var webVw: UIWebView!
       
        @IBOutlet weak var TxtViewContent: UILabel!

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
            
            ActivityIndicator.shared.show(self.view)
            
            DataManager.postAPIWithParameters(urlString: API.course_content_listing, jsonString: Request.oneCourseId(UserDefaults.standard.value(forKey: "auth_key") as! String,  getReview2) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                self.dict  = (sucess["body"] as? [String:Any])!
                let values = self.dict
                let allContent = values["course_content"] as! [[String:Any]]
                let QuestionsAnswer = allContent[1]
                
                self.contentArray = QuestionsAnswer["Questions"] as! [[String:Any]]
                
                
                for i in 0..<2
                {
                    let correct = self.contentArray[i]
                    self.correctanswer.append(correct["correct_answer"] as! String)
                }
                
               
                self.TxtViewContent.text = (QuestionsAnswer["content"] as? String)?.html2String
                self.TxtViewContent.isHidden = true
                let HtmlString = QuestionsAnswer["content"] as! String
                self.webVw.loadHTMLString(HtmlString, baseURL: nil)
                self.LblHeadingTitle.text = (QuestionsAnswer["chapter_name"] as! String) + " Part 2"
                self.TblVwContent.reloadData()
                
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
            
        }
      
        
        @IBAction func ActnSubmitBtn(_ sender: Any)
        {
            
            if selectedSection0 == 0 && selectedSection1 == 1
            {
                if selected0 == correctanswer[0]  && selected1 == correctanswer[1]
                    
                {
                   
                    
                }
                else
                {
                   
                }
                let vc = storyboard?.instantiateViewController(withIdentifier: "LectReviewVc3") as? LectReviewVc3
                vc?.getReview3 = getReview2
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            else
            {
                  self.alert()
            }
            
            
        }
    func alert()
    {
        let alert = UIAlertController(title: "MESSAGE", message: "Give Answers", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
        
    }
        
        func popUp()
        {
            let menuVC : PopUpVc = self.storyboard!.instantiateViewController(withIdentifier: "PopUpVc") as! PopUpVc
            menuVC.completedId = getReview2
            
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
    extension LectReviewVc2 : UITableViewDelegate,UITableViewDataSource
    {
        func numberOfSections(in tableView: UITableView) -> Int
        {
            return contentArray.count
        }
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
        {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
            label.backgroundColor = .white
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 0
            let text = contentArray[section]
            
            if text.index(forKey: "question") == nil
            {
                label.text = "Question not Available"
            }
            else
            {
                label.text = (text["question"] as! String)
            }
            
            return label
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
        {
            return 40.0
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return 4
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            
            let cell : CellQuestion2 = (tableView.dequeueReusableCell(withIdentifier: "CellQuestion2") as? CellQuestion2)!
            
            let value = contentArray[indexPath.section]
            
            cell.itemLabel.text = (value["option" + String(indexPath.row+1)] as! String)
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
            
            return cell
            
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            if indexPath.section == 0 {
                selectedSection0 = indexPath.section
                if correctanswer[0] == String(indexPath.row + 1)
                {
                    selected0 = correctanswer[0]
                }
                
                selectedIndexOpt0 = indexPath as NSIndexPath
            }
            else if indexPath.section == 1 {
                selectedSection1 = indexPath.section
                if correctanswer[1] == String(indexPath.row + 1)
                {
                    selected1 = correctanswer[1]
                }
                selectedIndexOpt1 = indexPath as NSIndexPath
            }
            
            tableView.reloadData()
            
        }
        func webViewDidStartLoad(_ webView: UIWebView)
        {
            ActivityIndicator.shared.show(self.view)
        }
        
        func webViewDidFinishLoad(_ webView: UIWebView)
        {
//            webView.frame.size.height = 1
//            webView.frame.size = webView.sizeThatFits(CGSize.zero)
            ActivityIndicator.shared.hide()
            
        }
        func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
        {
            UIAlertController.show(self, "Error", "While loading content")
        }
        
        
}

