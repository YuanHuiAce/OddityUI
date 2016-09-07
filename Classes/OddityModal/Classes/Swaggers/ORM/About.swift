//
//  About.swift
//  Journalism
//
//  Created by Mister on 16/6/6.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
public class About: Object {
    
    public dynamic var nid = 0 // 相关新闻地址
    public dynamic var url = "" // 相关新闻地址
    public dynamic var title = "" // 相关新闻标题
    public dynamic var from = "" // 新闻来源
    public dynamic var rank = 0 //点赞数
    public dynamic var pname = "" // 用户是否能对该条评论点赞，0、1 对应 可点、不可点
    
    public dynamic var ptime = "" // 评论正文
    public dynamic var img:String? = nil  //创建时间
    public dynamic var abs = "" //创建该评论的用户名
    
    public dynamic var ptimes = NSDate() //创建时间
    
    public dynamic var htmlTitle = "" // 相关新闻标题
    
    public dynamic var isread = 0 // 是否阅读
    
    override public static func primaryKey() -> String? {
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