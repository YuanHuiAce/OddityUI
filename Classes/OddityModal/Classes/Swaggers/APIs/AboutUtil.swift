//
//  AboutUtil.swift
//  Journalism
//
//  Created by Mister on 16/6/6.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

open class AboutUtil: NSObject {
    
    open class func getAboutListArrayData(_ new:New?,p: String?=nil, c: String?="90",finish:((_ count:Int)->Void)?=nil,fail:(()->Void)?=nil){
        guard let new = new else{ fail?(); return}
        
        let nillableParameters: [String:AnyObject?] = [
            "nid": new.nid as Optional<AnyObject> ,
            "p": p as Optional<AnyObject> ,
            "c": c as Optional<AnyObject>
        ]
        
        let urlString = SimpleRequest.basePath+"/ns/asc"
        
        let parameters = APIHelper.rejectNil(nillableParameters)
        let convertedParameters = APIHelper.convertBoolToString(parameters)
        
        let nid = new.nid
        
        SimpleRequest.budileRequest(urlString, method: .get, parameters: convertedParameters, encoding: URLEncoding.default, headers: nil).request { (datas, _, _) in
            
            guard let da = datas,let data = da["data"] as? NSArray else{ fail?();return}
            
            let realm = try! Realm()
            
            try! realm.write({
                
                for channel in data {
                    
                    if let pubTime = (channel as AnyObject).object(forKey: "ptime") as? String,let url = (channel as AnyObject).object(forKey: "url") as? String {
                        
                        realm.create(About.self, value: channel, update: true)
                        
                        realm.create(About.self, value: ["url":url,"nid":nid,"ptimes":Date(fromString: pubTime, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"))], update: true)
                        
                        let title = (channel as AnyObject).object(forKey: "title") as! String
                        
                        let attributed = try! NSMutableAttributedString(data: title.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
              
                        realm.create(About.self, value: ["url":url,"title":attributed.string,"htmlTitle":title], update: true)
                    }
                }
            })
            
            finish?(data.count)
        }
    }
}
