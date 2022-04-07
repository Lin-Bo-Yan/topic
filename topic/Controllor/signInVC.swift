//
//  signInVC.swift
//  topic
//
//  Created by Class on 2022/4/4.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftUI
class signInVC: UIViewController,UITextFieldDelegate{

    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 匿名驗證
        Auth.auth().signInAnonymously{(user,error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
       
        //隨時監聽DB內容
        let ref = Database.database().reference(withPath: "name")
        ref.observe(.value){(snapshot) in
            if let output = snapshot.value{
                
            }
        }
    }
    
    @IBAction func signInOnClick(_ sender: Any) {
        let ref = Database.database().reference()
        ref.removeAllObservers()
        ref.observe(.value){(snapshot) in
            print("這裏:\(snapshot)")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
