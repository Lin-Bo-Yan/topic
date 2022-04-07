//
//  headshoVC.swift
//  topic
//
//  Created by Class on 2022/4/6.
//

import UIKit

class headshoVC: UIViewController {
    let controller = UIAlertController(title: "拍照?從照片選取?從相簿選取?", message: "", preferredStyle: .alert)
       //controller.view.tintColor = UIColor.gray
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func pickFromSketchbook(_ sender: Any) {
         
    }
    
   
    @IBAction func photograph(_ sender: Any) {
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           // info 用來取得不同類型的圖片，此 Demo 的型態為 originaImage，其它型態有影片、修改過的圖片等等
           if let image = info[.originalImage] as? UIImage {

           }
           
           picker.dismiss(animated: true)
       }
    
    
}
