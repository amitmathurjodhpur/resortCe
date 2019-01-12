//
//  DocumentsVC.swift
//  ResortCeApp
//
//  Created by AJ12 on 19/09/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellDocuments:UITableViewCell
{
    @IBOutlet weak var LblHeading: UILabel!
}

class DocumentsVC: UIViewController {
 var URlArray = [URL]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            URlArray = fileURLs
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

}
extension DocumentsVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return URlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDocuments", for: indexPath) as! CellDocuments
        let fileName = String(describing: URlArray[indexPath.row])
        let array = fileName.components(separatedBy: "/")
        cell.LblHeading.text = array.last
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return  UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PDFViewVC") as! PDFViewVC
        vc.StringUrl = String(describing: URlArray[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
