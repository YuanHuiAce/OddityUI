//
//  About.swift
//  Journalism
//
//  Created by Mister on 16/6/6.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
open class About: Object {
    
    open dynamic var nid = 0 // 相关新闻地址
    open dynamic var url = "" // 相关新闻地址
    open dynamic var title = "" // 相关新闻标题
    open dynamic var from = "" // 新闻来源
    open dynamic var rank = 0 //点赞数
    open dynamic var pname = "" // 用户是否能对该条评论点赞，0、1 对应 可点、不可点
    
    open dynamic var ptime = "" // 评论正文
    open dynamic var img:String? = nil  //创建时间
    open dynamic var abs = "" //创建该评论的用户名
    
    open dynamic var ptimes = Date() //创建时间
    
    open dynamic var htmlTitle = "" // 相关新闻标题
    
    open dynamic var isread = 0 // 是否阅读
    
    override open static func primaryKey() -> String? {
        return "url"
    }
}

public extension About{
    
    public func isRead(){
        
        let realm = try! Realm()
        
        try! realm.write {
            
            self.isread = 1
        }
    }
}
