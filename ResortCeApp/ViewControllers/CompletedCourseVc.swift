//
//  CompletedCourseVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 08/05/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellCompletedCourse: UITableViewCell
{
    @IBOutlet weak var LblTitle: UILabel!
    
    @IBOutlet weak var ImageVw: UIImageView!
    @IBOutlet weak var LblQueAns: UILabel!
}

class CompletedCourseVc: UIViewController
{
    var CcourseId = ""
    var contentArray : [[String:Any]] = []
    var QuestionArray : [String:Any] = [:]
    var optionsArray : [[String:Any]] = []
    
    var correctanswer : [String] = []
    var dict : [String:Any] = [:]
    var questions : [String] = []
    
    @IBOutlet weak var ParentVw: UIView!
    @IBOutlet weak var TblVwContent: UITableView!
    
    @IBOutlet weak var TxtViewContent: UILabel!
    @IBOutlet weak var imgVwContent: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        ParentVw.layer.cornerRadius = 3
        ParentVw.layer.borderWidth = 2
        ParentVw.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
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
        
        DataManager.postAPIWithParameters(urlString: API.course_content_listing, jsonString: Request.oneCourseId(UserDefaults.standard.value(forKey: "auth_key") as! String, CcourseId) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            self.dict  = (sucess["body"] as? [String:Any])!
            let values = self.dict
            let allContent = values["course_content"] as! [[String:Any]]
            self.optionsArray = allContent
            
            for i in 0..<allContent.count
            {
                let QuestionsAnswer = allContent[i]
                self.contentArray = (QuestionsAnswer["Questions"] as! [[String : Any]] )
                for j in 0..<self.contentArray.count
                {
                let correct = self.contentArray[j]
                self.correctanswer.append(correct["correct_answer"] as! String)
                self.questions.append(correct["question"] as! String)
                }
            }
           
            
            
            let photo = values["course_image"] as? String
            self.imgVwContent.sd_setImage(with: URL(string: photo!), placeholderImage: UIImage(named: "Bed"))
            self.TxtViewContent.text = values["course_overview"] as? String
            self.TblVwContent.reloadData()
            
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
        
    }

}
extension CompletedCourseVc : UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return questions.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        label.backgroundColor = .white
        label.textColor = UIColor.black
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.text = questions[section]
        return label
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CellCompletedCourse") as? CellCompletedCourse
        
        
        
        
       //cell?.LblQueAns.text = (value["option" + String(indexPath.row+1)] as! String)
        
        
        return cell!
    }
    
    
}
