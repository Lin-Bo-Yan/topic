//
//  signInVC.swift
//  topic
//
//  Created by Class on 2022/4/4.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
class signInVC: UIViewController{
    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    var memberSignInVC: Member?
    var handle: AuthStateDidChangeListenerHandle?
    var goldfishBrain = ""
    var goToRegister = ""
    var exceed = ""
    var lowerThan = ""
    
    override func viewDidLoad() { //先執行它
        super.viewDidLoad()
        EmailText.delegate = self
        navigationItem.hidesBackButton = true //隱藏 back 按鍵
        multilingual() // 多語系設定
    }
    
    // 監聽器
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ auth, user in
            guard user != nil else{
                print("沒有監聽到資料")
                return
            }
            guard
                let email = user?.email,
                let nickName = user?.displayName
            else {
                //self.nameID = "訪客wells"
                print("有資料，但拿的時候出問題了")
                return
            }
        })
    } // viewWillAppear

    
    
    @IBAction func signInOnClick(_ sender: UIButton) {
        let eMailTextBtn = EmailText.text ?? ""
        let passWordBtn = passWordText.text ?? ""
        guard
            eMailTextBtn != "" || passWordBtn != ""
        else{
            CustomToast.show(message: self.goToRegister, bgColor: .cyan, textColor: .yellow, labelFont: .boldSystemFont(ofSize: 20), showIn: .bottom, controller: self)
            sender.isEnabled = true //讓他有該有的功能
            return
        }
        
        Auth.auth().signIn(withEmail: eMailTextBtn, password: passWordBtn){
            result,error in
            guard let user = result?.user,
                  error == nil else{
                CustomToast.show(message: self.goldfishBrain, bgColor: .red, textColor: .black, labelFont: .boldSystemFont(ofSize: 20), showIn: .top, controller: self)
                return
                  }
            
            //登入成功頁面跳轉
            if let user = Auth.auth().currentUser {
                print("\(user.uid) 成功")
                //登入成功頁面跳轉
                self.memberSignInVC = Member(eMailTextBtn as! String)
                self.performSegue(withIdentifier: "ToIndexScreen", sender: self)
            } }
        
            } // signInOnClick
    
    //map(String.init(describing:)) ?? "nil" 取出所有的值
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // 滾動收鍵盤
     func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)  //沒有功能
    }

    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if let memberProfileVC = segue.destination as? memberProfileVC{
            memberProfileVC.member = memberSignInVC

        }
    }
    // 多語系設定
    func multilingual(){
        goldfishBrain = NSLocalizedString("goldfishBrain", comment: "金魚腦！密碼錯誤!")
        goToRegister = NSLocalizedString("goToRegister", comment: "來去註冊")
        exceed = NSLocalizedString("exceed", comment: "長度超過20字元")
        lowerThan = NSLocalizedString("lowerThan", comment: "長度低於4字元")
    }
}
// [A-Z0-9a-z]+@[A-Za-z0-9]+\\.[A-Za-z]{2,64}
extension signInVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count > 0 {
            let result = replce(pattern: "[^A-Za-z0-9@.]", source: string, to: "")
            if result.count == 0{
                return false
            }
            
            if range.location > 19 {
                CustomToast.show(message: self.exceed, bgColor: .blue, textColor: .yellow, labelFont: .boldSystemFont(ofSize: 20), showIn: .top, controller: self)
                return false
            }

            if range.location < 4 {
                CustomToast.show(message: self.lowerThan, bgColor: .separator, textColor: .systemIndigo, labelFont: .boldSystemFont(ofSize: 20), showIn: .top, controller: self)
            }
            
        }
        return true
    }

    func replce(pattern:String,source:String,to:String) -> String{
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let result = regex.stringByReplacingMatches(in: source, options: [], range: NSMakeRange(0, source.count), withTemplate: to)

        return result
    }
}
















/*
 設定資料
 let ref = Database.database().reference()
 ref.child("name").childByAutoId().setValue(EmailText.text)
 */

/*
 讀取資料
 
 let ref = Database.database().reference()
 ref.removeAllObservers()
 ref.observe(.value){(snapshot) in
     print("這裏:\(snapshot)")
 */

/*
 let alertController = UIAlertController(
        title: "提示",
        message: "一個簡單提示，請按確認繼續",
        preferredStyle: .alert)
 
 let okAction = UIAlertAction(
        title: "確認",
        style: .default,
        handler: {
        (action: UIAlertAction!) -> Void in
          print("按下確認後，閉包裡的動作")
    })
 
 */


/*
 方法 1
if let user = Auth.auth().currentUser {
    print("\(user.uid) 成功")
    //登入成功頁面跳轉
        self.performSegue(withIdentifier: "ToIndexScreen", sender: self)
} else {}
*/


/*
 方法 2
 Auth.auth().addStateDidChangeListener { auth, user in
    if let user = user {
        print("\(user.uid) login")
    } else {
        print("not login")
    }
 }
 */

/*
 Auth.auth().signIn(withEmail: self.EmailText.text!, password: self.passWordText.text!){ result, error in
     guard error == nil else {
        print(error?.localizedDescription)
        return
     }
     print("登入成功")
}
 */





/*
 登入Authentication
 
 print(EmailText.text)
 print(passWordText.text)
 
 Auth.auth().signIn(withEmail: EmailText.text!, password: passWordText.text!){
     result,error in
     guard let user = result?.user,
           error==nil else{
         
         let alertController = UIAlertController(
                title: "金魚腦！",
                message: "一個簡單提示",
                preferredStyle: .alert)
         
         let okAction = UIAlertAction(
                title: "確認",
                style: .default,
                handler: {
                (action: UIAlertAction!) -> Void in
                  print("按下確認後，閉包裡的動作")
            })
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
               print("登入失敗:\(error?.localizedDescription)")
               return
           }
     
     //登入成功頁面跳轉
     if let user = Auth.auth().currentUser {
         print("\(user.uid) 成功")
         //登入成功頁面跳轉
         self.performSegue(withIdentifier: "ToIndexScreen", sender: self)} }

 */


/**
 //隨時監聽DB內容
 let ref = Database.database().reference(withPath: "name")
 ref.observe(.value){(snapshot) in
     if let output = snapshot.value{}
 }
 */

/**
 // signInOnClick
 let ref = Database.database().reference()
 ref.removeAllObservers()
 ref.observe(.value){(snapshot) in
     print("這裏:\(snapshot)")
 }
 */
// let snapshotData = snapshot.data().map(String.init(describing:)) ?? "nil" 取全部的值


//self.verify(passWordBtn,passWordData as! String)
//    func verify(_ optional :String ,_ optionalTwo :String ){
//        if(optional == optionalTwo){
//            print("密碼正確")
//        }else{
//            print("密碼錯誤")
//        }
//    }


// 換頁
//                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "memberProfileVC") as? memberProfileVC
//                            { controller.modalPresentationStyle = .fullScreen
//                                    self.present(controller, animated: true, completion: nil)
//                            }

//用 firestore 做登入判定 但是不能判定帳號
/*
 let reference = Firestore.firestore().collection("玩家")
 reference.document(eMailTextBtn).getDocument{(snapshop, error) in
     if let error = error
     {
         CustomToast.show(message: "信箱錯誤", bgColor: .red, textColor: .black, labelFont: .boldSystemFont(ofSize: 15), showIn: .top, controller: self)
         //print("閉包錯誤：\(error.localizedDescription)")
     }else{
         if let snapshot = snapshop
         {
             let passWordData = snapshot.data()?["密碼"] // 這個值取出來是Any型別 需要轉型成String
             let eMailData = snapshot.data()?["信箱"]
             
             guard
                 passWordBtn == passWordData as! String
             else{
                 CustomToast.show(message: "密碼錯誤", bgColor: .red, textColor: .black, labelFont: .boldSystemFont(ofSize: 15), showIn: .top, controller: self)
                 return
             }
             self.memberSignInVC = Member(eMailData as! String)
             self.performSegue(withIdentifier: "ToIndexScreen", sender: self)
         }
     }
 }
 */
