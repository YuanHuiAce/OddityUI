//
//  CommentUtil.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift
import AFDateHelper

extension New{

    /**
     将 新闻的 评论 url进行 base64 加密。处理
     
     - returns: <#return value description#>
     */
    func docidBase64() -> String{
        
        if let plainData = self.docid.dataUsingEncoding(NSUTF8StringEncoding){
            
            return plainData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        }
        
        return ""
    }
}


public class CommentUtil: NSObject {

    /// 获取普通评论列表
    public class func LoadNoramlCommentsList(new:New,p: String?="1", c: String?="20",finish:((count:Int)->Void)?=nil,fail:(()->Void)?=nil) {
        
        CommentAPI.nsComsCGet(did: new.docidBase64(), uid: "\(ShareLUser.uid)", p: p, c: c) { (datas, error) in
            
            if let code = datas?.objectForKey("code") as? Int{
                if code == 2002 {
                    finish?(count: 0)
                    return
                }
            }
            guard let da = datas,let data = da.objectForKey("data") as? NSArray else{ fail?();return}
            
            let realm = try! Realm()
            try! realm.write({
                for channel in data {
                    realm.create(Comment.self, value: channel, update: true)
                    self.AnalysisComment(channel as! NSDictionary, realm: realm,new:new)
                }
            })
            finish?(count: data.count)
        }
    }
    
    /// 获取热门评论列表
    public class func LoadHotsCommentsList(new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil) {
        
        CommentAPI.nsComsHGet(did: new.docidBase64(), uid: "\(ShareLUser.uid)") { (datas, error) in
            
            guard let da = datas,let data = da.objectForKey("data") as? NSArray else{ fail?();return}
            
            let realm = try! Realm()
            try! realm.write({
                for channel in data {
                    
                    realm.create(Comment.self, value: channel, update: true)
                    self.AnalysisComment(channel as! NSDictionary, realm: realm,new:new)
                    if let nid = channel.objectForKey("id") as? Int {
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
    private class func AnalysisComment(channel:NSDictionary,realm:Realm,new:New){
        
        if let nid = channel.objectForKey("id") as? Int {
            
            var date = NSDate()
            
            if let pubTime = channel.objectForKey("ctime") as? String {
                
                date = NSDate(fromString: pubTime, format: DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))
            }
            
            realm.create(Comment.self, value: ["id":nid,"nid":new.nid,"ctimes":date], update: true)
        }
    }
}