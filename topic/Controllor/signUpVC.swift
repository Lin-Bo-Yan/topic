//
//  signUpVC.swift
//  topic
//
//  Created by 林宇智 on 2022/4/3.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
class signUpVC: UIViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let database = Firestore.firestore()
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        Auth.auth().signInAnonymously{(result,error) in if let error = error{print(error.localizedDescription)}}
    }
    // 按鈕尚未完成
    @IBAction func ButtonOnClick(_ sender: Any) {
        
        let reference = Firestore.firestore()
        if let nickNameBtn = nickName.text,
           let EmailTextBtn = EmailText.text,
           let passWordBtn = passWordText.text
        {
            let newData = ["暱稱":nickNameBtn,"信箱":EmailTextBtn,"密碼":passWordBtn] as [String:Any]
            reference.collection("玩家").document(EmailTextBtn).setData(newData)
            {
                (error) in if let error = error{
                                    print(error.localizedDescription)
                                }else{
                                    let alertController = UIAlertController(
                                           title: "註冊成功！",
                                           message: nil,
                                           preferredStyle: .alert)
                                    
                                    let okAction = UIAlertAction(
                                           title: "確認",
                                           style: .default,
                                           handler: nil)
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
            }
        }
       
    }
    @IBAction func replace(_ sender: Any) {
        let controller = UIAlertController(title: "拍照?從照片選取?從相簿選取?", message: "", preferredStyle: .alert)
            controller.view.tintColor = UIColor.gray
        
        // 相機
            let cameraAction = UIAlertAction(title: "相機", style: .default) { _ in
                self.takePicture()
            }
            controller.addAction(cameraAction)

            // 相薄
            let savedPhotosAlbumAction = UIAlertAction(title: "相簿", style: .default) { _ in
                self.openPhotosAlbum()
            }
            controller.addAction(savedPhotosAlbumAction)

            let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
            controller.addAction(cancelAction)

            self.present(controller, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /// 開啟相機
    func takePicture() {
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true)
    }

    /// 開啟相簿
    func openPhotosAlbum() {
        imagePickerController.sourceType = .savedPhotosAlbum
        self.present(imagePickerController, animated: true)
    }
    
    // 用來處理選取完照片後的 function ，實作：UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // info 用來取得不同類型的圖片，此 Demo 的型態為 originaImage，其它型態有影片、修改過的圖片等等
        if let image = info[.originalImage] as? UIImage {
            self.photoImageView.image = image
        }

        picker.dismiss(animated: true)
    }
    
    
}










/*
 // 註冊按鈕
 Auth.auth().createUser(withEmail: EmailText.text!, password: passWordText.text!){
     result,error in
     guard let user = result?.user,
           error==nil else{
         //註冊失敗，看能不能不要有確認按鈕，點空白處就關掉視窗
         let alertController = UIAlertController(
                title: "註冊失敗！",
                message: "請輸入正確格式！",
                preferredStyle: .alert)
         
         let okAction = UIAlertAction(
                title: "確認",
                style: .default,
                handler: {
                (action: UIAlertAction!) -> Void in})
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
                print(error?.localizedDescription)
               return
           }
     // 返回訊息告訴使用者註冊成功
     print(user.email,user.uid)
     
     let ref = Database.database().reference()
                 let aDict = ["Nickname":self.nickName.text!,"Email":self.EmailText.text!,"Password":self.passWordText.text!,"isSignIn":"0","isSignUp":"1" ]

                 ref.child("User").child(self.nickName.text!).setValue(aDict)
 }

 */

//匿名驗證
//        if  (nickName.text == "" || EmailText.text == "" || passWordText.text == ""){
//            let alertController = UIAlertController(
//                   title: "輸入正確格式！",
//                   message: nil,
//                   preferredStyle: .alert)
//
//            let okAction = UIAlertAction(
//                   title: "確認",
//                   style: .default,
//                   handler: nil)
//            alertController.addAction(okAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
