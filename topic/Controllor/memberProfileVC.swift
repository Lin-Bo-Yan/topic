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
    
    //Dechange  實作搜尋
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true //隱藏 back 按鍵
        
        var text = ""
         if let member = member {
            text.append(contentsOf: member.info)
             accountTxt.text = text
             } else {
            text = "no data found"
        }
        
        let reference = Firestore.firestore().collection("玩家")
        reference.document(text).getDocument{(snapshop, error) in
            if let error = error
            {
                print("閉包錯誤：\(error.localizedDescription)")
            }
            if let snapshot = snapshop
            {
                let nickNameData = snapshot.data()?["暱稱"]
                self.nickNameTxt.text = nickNameData as! String
            }
            DispatchQueue.main.async {
                self.memberProfileVC.viewDidLoad()
            }
        }
    }
    
    @IBAction func onSignOutBtn(_ sender: Any){
        self.performSegue(withIdentifier: "onSignOutBtn", sender: self)
    }
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        
    }
//    func ddd(_ document : String) -> String {
//        var tt = ""
//        let reference = Firestore.firestore().collection("玩家")
//        reference.document(document).getDocument{(snapshop, error) in
//            if let error = error
//            {
//                print("閉包錯誤：\(error.localizedDescription)")
//            }
//            if let snapshot = snapshop
//            {
//                let nickNameData = snapshot.data()?["暱稱"]
//                tt = nickNameData as! String
//                //self.nickNameTxt.text = nickNameData as! String
//            }
//            DispatchQueue.main.async {
//                self.memberProfileVC.viewDidLoad()
//            }
//        }
//       return tt
//    }
}
