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
import FirebaseStorage

class signUpVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let database = Firestore.firestore()
    let imagePickerController = UIImagePickerController() // 可以存圖片
    
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    var correctFormat = ""
    var select = ""
    var camera = ""
    var album = ""
    var wrongFormat = ""
    var registrationSuccess = ""
    var confirm = ""
    var cancel = ""
    var giveMeText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        multilingual() // 多語系設定
    }
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().signInAnonymously{(result,error) in if let error = error{print(error.localizedDescription)}}
    }
    
    @IBAction func ButtonOnClick(_ sender: Any) {
           let nickNameBtn = nickName.text ?? ""
           let EmailTextBtn = EmailText.text ?? ""
           let passWordBtn = passWordText.text ?? ""
        guard
            EmailTextBtn != ""  || nickNameBtn != "" || passWordBtn != ""
        else
        {
            CustomToast.show(message: self.giveMeText, bgColor: .cyan, textColor: .yellow, labelFont: .boldSystemFont(ofSize: 20), showIn: .bottom, controller: self)
            return
        }
        
        if cheackIfEmailFormat(EmailTextBtn) == true && isPassWordValid(passWordBtn) == true
        {
            authentication(emailTextAuth: EmailTextBtn, passWordTextAuth: passWordBtn)
        }else{
            CustomToast.show(message: self.correctFormat, bgColor: .purple, textColor: .green, labelFont: .boldSystemFont(ofSize: 20), showIn: .top, controller: self)
        }
    }
    
    
    @IBAction func replace(_ sender: Any) {
        let controller = UIAlertController(title: self.select, message: "", preferredStyle: .alert)
            controller.view.tintColor = UIColor.gray
        
        // 相機
        let cameraAction = UIAlertAction(title: self.camera, style: .default) { _ in
                self.takePicture()
            }
            controller.addAction(cameraAction)

            // 相薄
        let savedPhotosAlbumAction = UIAlertAction(title: self.album, style: .default) { _ in
                self.openPhotosAlbum()
            }
            controller.addAction(savedPhotosAlbumAction)

        let cancelAction = UIAlertAction(title: self.cancel, style: .destructive, handler: nil)
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
    
    func upload(imageFileName:String,image:UIImage ,imgName:String)  { //imageFileName 料夾位置
        //建立 storage 服務
        let storageRef = FirebaseStorage.Storage.storage().reference().child(imageFileName).child(imgName)
        //將UIImage轉Data
        if let imData = image.jpegData(compressionQuality: 0.7)
        {
            storageRef.putData(imData,metadata: nil){
                storageMetadata , error in
                guard
                    error == nil
                else{
                    
                    print("上傳個人頭像失敗\(imData)")
                    return
                }
                print("上傳個人頭像成功")
            }
        }else{
            print("圖片轉檔失敗")
        }
    }
    
    
    func authentication(emailTextAuth:String,passWordTextAuth:String){
        FirebaseAuth.Auth.auth().createUser(withEmail: emailTextAuth, password: passWordTextAuth){
            result, error in
            guard let user = result?.user,
                  error == nil else {
                CustomToast.show(message: self.wrongFormat, bgColor: .red, textColor: .black, labelFont: .boldSystemFont(ofSize: 15), showIn: .top, controller: self)
                print("電子郵件地址格式錯誤:\(error?.localizedDescription)")
                return
            }
            print(user.email, user.uid)
            guard let changRequest = Auth.auth().currentUser?.createProfileChangeRequest() else {
                print("創建changRequest時發生錯誤")
                return
            }
            guard
                let myNickName = self.nickName.text // 暱稱直接進來，就沒透過參數傳進來
            else{
                print("儲存暱稱時發生錯誤")
                return
            }
            changRequest.displayName = myNickName
            changRequest.commitChanges { err in
                
                guard err == nil else {
                    print("上傳暱稱時發生錯誤")
                    return
                }
                let alertController = UIAlertController(
                    title: self.registrationSuccess,
                       message: nil,
                       preferredStyle: .alert)
                
                let okAction = UIAlertAction(
                    title: self.confirm,
                       style: .default,
                       handler: { alertAction in
                           self.navigationController?.popViewController(animated: true)
                           //self.dismiss(animated: true)
                       }
                )
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }// authentication
    
    // 多語系設定
    func multilingual(){
        correctFormat = NSLocalizedString("correctFormat", comment: "請輸入正確格式")
        giveMeText = NSLocalizedString("giveMeText", comment: "要給我文字吃喔!")
        select = NSLocalizedString("select", comment: "拍照?從照片選取?從相簿選取?")
        camera = NSLocalizedString("camera", comment: "相機")
        album = NSLocalizedString("album", comment: "相簿")
        wrongFormat = NSLocalizedString("wrongFormat", comment: "格式錯誤")
        registrationSuccess = NSLocalizedString("registrationSuccess", comment: "註冊成功！")
        confirm = NSLocalizedString("confirm", comment: "確認")
        cancel = NSLocalizedString("cancel", comment: "取消")
    }
}
// 檢查是否為Email格式
func cheackIfEmailFormat(_ mail:String) -> Bool{
    var retureValue = false
    let mailPattern = "^([a-za-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    let mailRegular = try! NSRegularExpression(pattern: mailPattern, options: .caseInsensitive)
    let results = mailRegular.matches(in: mail, options: [], range: NSMakeRange(0, (mail as NSString).length))
    if results.count > 0{
        retureValue = true
    }
    return retureValue
}

// 檢查密碼格式
func isPassWordValid(_ password:String) -> Bool {
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^[a-za-z0-9]{6,12}+$")
    return passwordTest.evaluate(with: password)
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
//


//if let controller = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as? signInVC
//                                               { controller.modalPresentationStyle = .fullScreen
//                                                   self.present(controller, animated: true, completion: nil)
//                                               }



// 用 firestore 當成註冊功能
/*
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
                                           handler: { alertAction in
                                               self.dismiss(animated: true)
                                           }
                                    )
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
            }
        }
       */

/*
func upload(_ image: UIImage,_ accountAddress:String, completion: @escaping (Result<URL, Error>) -> Void) {
    let data = image.jpegData(compressionQuality: 0.5)

      // Change the content type to jpg. If you don't, it'll be saved as application/octet-stream type
      let metadata = StorageMetadata()
      metadata.contentType = "image.jpeg"
    
    let path = "image/\(UUID().uuidString).jpg" //總路徑
    let storageRef = Storage.storage().reference().child(path)
    
      // Upload the image
      if let data = data {
          storageRef.putData(data, metadata: nil) { result,user  in
              print(result)
              switch result {
              case .failure(let error):
                  print("data錯誤：\(error)")
                  completion(.failure(error))
              case .success(_):
                  storageRef.downloadURL { result in
                      switch result {
                      case .success(let url):
                          completion(.success(url))
                      case .failure(let error):
                          completion(.failure(error))
                          print("url錯誤：\(error)")
                      }
                  }
          }
          }
          
      }
}  // upload
*/
