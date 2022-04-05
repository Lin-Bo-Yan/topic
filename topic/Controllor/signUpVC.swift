//
//  signUpVC.swift
//  topic
//
//  Created by 林宇智 on 2022/4/3.
//

import UIKit
import Firebase
import FirebaseAuth
class signUpVC: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func ButtonOnClick(_ sender: Any) {
        print(EmailText.text)
        print(passWordText.text)
        Auth.auth().createUser(withEmail: EmailText.text!, password: passWordText.text!){
            result,error in
            guard let user = result?.user,
                  error==nil else{
                      print(error?.localizedDescription)
                      return
                  }
            print(user.email,user.uid)
            // 返回訊息告訴使用者成功
        }
        //  暱稱Db 另外存
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

