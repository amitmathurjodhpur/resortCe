//
//  ReceiptViewController.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 4/7/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgPhoto: UIImageView!
    var imagePath: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        imgPhoto?.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "Bed"))
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
    }
     
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgPhoto
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
