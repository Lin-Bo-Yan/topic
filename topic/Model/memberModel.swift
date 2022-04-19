//
//  memberModel.swift
//  topic
//
//  Created by Class on 2022/4/10.
//
class Member {
    var eMail: String
    
    init( _ eMail: String) {
        self.eMail = eMail
    }
    
    var info: String {
//      let text = "neMail = \(eMail)"
        let text = eMail
        return text
    }
}



























//    var nickName: String
//    var passWord: String
    
//    init(_ nickName: String, _ eMail: String, _ passWord: String) {
//        self.nickName = nickName
//        self.eMail = eMail
//        self.passWord = passWord
//    }
//
//    var info: String {
//        let text = "nickName = \(nickName)\neMail = \(eMail)\npassWord = \(passWord)\n"
//        return text
//    }
