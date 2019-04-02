//
//  ResortceViewController.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 1/13/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import UIKit

class ResortceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
        self.title = "Resortce Concierge"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "resortcecell") {
            if indexPath.row == 0 {
               cell.textLabel?.text = "Find CE Courses"
               cell.imageView?.image = UIImage(named: "findCE")
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Track Trip Expenses"
                cell.imageView?.image = UIImage(named: "expense")
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "In progress courses"
                cell.imageView?.image = UIImage(named: "LectProgIcon")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            /*let vc = storyboard?.instantiateViewController(withIdentifier: "FindLocationVc") as? FindLocationVc
            self.navigationController?.pushViewController(vc!, animated: true)*/
            let vc = storyboard?.instantiateViewController(withIdentifier: "hotellistvc") as? HotelListViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else  if indexPath.row == 2 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LockerVc") as? LockerVc
            self.navigationController?.pushViewController(vc!, animated: true)
        } else  if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LockerVc") as? LockerVc
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
