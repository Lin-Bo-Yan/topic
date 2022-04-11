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
class signInVC: UIViewController,UITextFieldDelegate{

    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    var memberSignInVC: Member?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 匿名驗證
        Auth.auth().signInAnonymously{(user,error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        navigationItem.hidesBackButton = true //隱藏 back 按鍵
    }
    
    @IBAction func signInOnClick(_ sender: Any) {
        let eMailTextBtn = EmailText.text ?? ""
        let passWordBtn = passWordText.text ?? ""
        if  eMailTextBtn != "" || passWordBtn != "" { //判斷用戶是否沒輸入
            
            let reference = Firestore.firestore().collection("玩家")
            reference.document(eMailTextBtn).getDocument{(snapshop, error) in
                if let error = error
                {
                    print("閉包錯誤：\(error.localizedDescription)")
                }
                    if let snapshot = snapshop
                    {
                        let passWordData = snapshot.data()?["密碼"] // 這個值取出來是Any型別 需要轉型成String
                        let eMailData = snapshot.data()?["信箱"]
                        if(passWordBtn == passWordData as! String){
                            self.memberSignInVC = Member(eMailData as! String)
                            self.performSegue(withIdentifier: "ToIndexScreen", sender: self)
                        }else{
                            print("密碼錯誤")
                        }
                    }
            }

        }else{
            print("可能沒有這組帳號密碼")
        }
        
            }
    //map(String.init(describing:)) ?? "nil" 取出所有的值
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if let memberProfileVC = segue.destination as? memberProfileVC{
            memberProfileVC.member = memberSignInVC

        }
    }
    
    
//self.verify(passWordBtn,passWordData as! String)
//    func verify(_ optional :String ,_ optionalTwo :String ){
//        if(optional == optionalTwo){
//            print("密碼正確")
//        }else{
//            print("密碼錯誤")
//        }
//    }
    
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
