//
//  CommentUtil.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

extension New{
    
    /**
     将 新闻的 评论 url进行 base64 加密。处理
     
     - returns: <#return value description#>
     */
    func docidBase64() -> String{
        
        if let plainData = self.docid.data(using: String.Encoding.utf8){
            
            return plainData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        }
        
        return ""
    }
}


open class CommentUtil: NSObject {
    
    /// 获取普通评论列表
    open class func LoadNoramlCommentsList(_ new:New,p: String?="1", c: String?="20",finish:((_ count:Int)->Void)?=nil,fail:(()->Void)?=nil) {
        
        CommentAPI.nsComsCGet(did: new.docidBase64(), uid: "\(ShareLUser.uid)", p: p, c: c) { (datas, error) in
            
            if let code = datas?.object(forKey: "code") as? Int{
                if code == 2002 {
                    finish?(0)
                    return
                }
            }
            guard let da = datas,let data = da.object(forKey: "data") as? NSArray else{ fail?();return}
            
            let newid = new.nid
            
            let realm = try! Realm()
            try! realm.write({
                for channel in data {
                    realm.create(Comment.self, value: channel, update: true)
                    self.AnalysisComment(channel as! NSDictionary, realm: realm,new: newid)
                }
            })
            finish?(data.count)
        }
    }
    
    /// 获取热门评论列表
    open class func LoadHotsCommentsList(_ new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil) {
        
        CommentAPI.nsComsHGet(did: new.docidBase64(), uid: "\(ShareLUser.uid)") { (datas, error) in
            
            guard let da = datas,let data = da.object(forKey: "data") as? NSArray else{ fail?();return}
            
            let newid = new.nid
            
            let realm = try! Realm()
            try! realm.write({
                for channel in data {
                    
                    realm.create(Comment.self, value: channel, update: true)
                    self.AnalysisComment(channel as! NSDictionary, realm: realm,new : newid)
                    if let nid = (channel as AnyObject).object(forKey: "id") as? Int {
                        realm.create(Comment.self, value: ["id":nid,"ishot":1], update: true)
                    }
                }
            })
            finish?()
        }
    }
    
    
}

extension CommentUtil{
    // 完善评论对象
    fileprivate class func AnalysisComment(_ channel:NSDictionary,realm:Realm,new:Int){
        
        if let nid = channel.object(forKey: "id") as? Int {
            
            var date = Date()
            
            if let pubTime = channel.object(forKey: "ctime") as? String {
                
                date = Date(fromString: pubTime, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"))
            }
            
            realm.create(Comment.self, value: ["id":nid,"nid":new,"ctimes":date], update: true)
        }
    }
}
