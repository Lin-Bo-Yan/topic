//
//  memberProfileVC.swift
//  topic
//
//  Created by Class on 2022/4/10.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
class memberProfileVC: UIViewController {

    @IBOutlet weak var accountTxt: UILabel!
    @IBOutlet weak var nickNameTxt: UILabel!
    var member: Member?
    var eMailData : String?
    var nickNameData : String?
    let memberProfileVC = UIViewController()
    var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true //隱藏 back 按鍵
        var eMail = ""
         if let member = member {
             eMail.append(contentsOf: member.info)
             accountTxt.text = eMail
             //saveData(values: eMail, Key: "eMailKey") // 儲存信箱
             } else {
                 eMail = "no E-Mail found"
        }
        

    } // viewDidLoad
    
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
                self.nickNameTxt.text = nickName
        })
    } // viewWillAppear
    
    @IBAction func onSignOutBtn(_ sender: Any){
        do {
            try? Auth.auth().signOut()
            performSegue(withIdentifier: "onSignOutBtn", sender: self)
        } catch  {
            print("登出時發生錯誤：\(error)")
        }
    }
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        
    }
    /** 將資料存檔 */
    func saveData(values:String, Key:String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(values, forKey:Key )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // 用 Firestore 去抓裡面的資料然後存到
  /*
   var eMail = ""
    if let member = member {
        eMail.append(contentsOf: member.info)
        accountTxt.text = eMail
        //saveData(values: eMail, Key: "eMailKey") // 儲存信箱
        } else {
            eMail = "no E-Mail found"
   }
   
   let reference = Firestore.firestore().collection("玩家")
   reference.document(eMail).getDocument{(snapshop, error) in
       if let error = error
       {
           print("閉包錯誤：\(error.localizedDescription)")
       }
       if let snapshot = snapshop
       {
           let nickNameData = snapshot.data()?["暱稱"]
           //print(nickNameData)
           self.nickNameTxt.text = nickNameData as! String
           CustomToast.show(message: "好久不見！", controller: self)
           // 暱稱儲存到 userDefaults
           //self.saveData(values: nickNameData as! String, Key: "nickNameKey") // 儲存暱稱
       }
       DispatchQueue.main.async {
           self.memberProfileVC.viewDidLoad()
       }
   }
   */
    
    
    
    
    
    
    
    
    
    
}
