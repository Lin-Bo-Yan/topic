//
//  signUpVC.swift
//  topic
//
//  Created by 林宇智 on 2022/4/3.
//

import UIKit
import Firebase
import FirebaseAuth
class signUpVC: UIViewController {


   
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
 
    
    @IBAction func buttonclick(_ sender: Any) {
        print(emailtext.text)
        print(passwordtext.text)
        Auth.auth().createUser(withEmail: emailtext.text!, password: passwordtext.text!){
            result,error in
            guard let user = result?.user,
                  error==nil else{
                      print(error?.localizedDescription)
                      return
                  }
            print(user.email,user.uid)
        }
    
    }
    

}
