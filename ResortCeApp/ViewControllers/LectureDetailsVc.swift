//
//  LectureDetailsVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 12/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellHeading : UITableViewCell
{
    
}
class CellSubDetails: UITableViewCell
{
    
}
class LectureDetailsVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
 
}
extension LectureDetailsVc : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellHeading")
        return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSubDetails") as? CellSubDetails
        return cell!
    }
}
