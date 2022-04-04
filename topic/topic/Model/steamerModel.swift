//
//  steamerModel.swift
//  topic
//
//  Created by Class on 2022/4/4.
//
struct mySteamer:Codable{
    let myResult:result
}

struct result :Codable{
    let myStream_list:[stream_list]
}

struct stream_list:Codable{
    var head_photo:String
    var nickname:String
    var online_num:Int
    var stream_title:String
    var tags:String
}
