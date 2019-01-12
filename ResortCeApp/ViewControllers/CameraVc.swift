//
//  CameraVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 27/03/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CameraVc: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openCameraButton(sender: self)
    }
    func openCameraButton(sender: AnyObject)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
           let Alert = UIAlertController(title: "Message", message: "You Don't Have Camera Access", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.Back()
            }))
            self.present(Alert, animated: true, completion: nil)
        }
    }
    func Back()
    {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}
extension CameraVc : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // UserImage.image = image
        dismiss(animated: true, completion: nil)
        self.Back()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
        self.Back()
    }
}
