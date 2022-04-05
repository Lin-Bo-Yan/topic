//
//  signInVC.swift
//  topic
//
//  Created by Class on 2022/4/4.
//

import UIKit
import Firebase
import FirebaseAuth
class signInVC: UIViewController,UITextFieldDelegate{

    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func signInOnClick(_ sender: Any) {
        print(EmailText.text)
        print(passWordText.text)
        Auth.auth().signIn(withEmail: EmailText.text!, password: passWordText.text!){
            result,error in
            guard let user = result?.user,
                  error==nil else{
                      print(error?.localizedDescription)
                      return
                  }
            print(user.email,user.uid)
            
            if let user = Auth.auth().currentUser {
                print("\(user.uid) 成功")
                //登入成功頁面跳轉
                    //self.performSegue(withIdentifier: "ToIndexScreen", sender: sender)
            } else {
                print("登入失敗")
            }
        }
        //  暱稱Db 另外
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
