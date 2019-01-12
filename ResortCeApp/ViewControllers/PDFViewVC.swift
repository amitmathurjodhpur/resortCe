//
//  PDFViewVC.swift
//  ResortCeApp
//
//  Created by AJ12 on 19/09/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class PDFViewVC: UIViewController {
     @IBOutlet weak var webVw: UIWebView!
    var StringUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if StringUrl != ""
        {
        let url = NSURL (string: StringUrl)
        let requestObj = NSURLRequest(url: url! as URL)
        webVw.loadRequest(requestObj as URLRequest)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func ActnShareBtn(_ sender: UIButton)
    {
        let objectsToShare:URL = URL(string: StringUrl)!
        let shareAll = [objectsToShare as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        ActivityIndicator.shared.show(self.view)
    }
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        ActivityIndicator.shared.hide()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        UIAlertController.show(self, "Error", "While loading content")
    }

}
