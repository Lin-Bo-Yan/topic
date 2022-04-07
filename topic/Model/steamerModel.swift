//
//  steamerModel.swift
//  topic
//
//  Created by Class on 2022/4/4.
//

struct mySteamer : Codable{
    let result : result
}

struct result : Codable{
    let stream_list : [stream_list]
}

struct stream_list : Codable{
    var head_photo:String
    var nickname:String
    var online_num:Int
    var stream_title:String
    var tags : String
}
// 大括號表一個物件 中括號表陣列
//用陣列包起來就用中括號

