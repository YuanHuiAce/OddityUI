//
//  User.swift
//  Journalism
//
//  Created by Mister on 16/5/27.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import Alamofire
import RealmSwift

let USERLOGINCHANGENOTIFITION = "USERLOGINCHANGENOTIFITION" // 用户登录成功或者注销完成

// MARK: NSUSer 存储信息名称
private let USER_ISLOGIN = "USERISLOGIN" // 存储的用户是否登陆
private let USER_UID = "USERUID" // 存储的用户Id
private let USER_TOKEN = "USERTOKEN" //  存储的用户token
private let USER_TYPE = "USERYTYPE" //  用户类型
private let USER_PASSWORD = "USERPASSWORD" //  存储的用户密码
private let USER_NAME = "USERNAME" //  存储的用户名称
private let USER_AVATAR = "USERAVATAR" //  存储的用户头像
private let S_USER_UID = "SUSERUID" //  第三方用户的ID
private let S_USER_TOKEN = "SUSERTOKEN" //  第三方用户的ID
private let S_USER_UNAME = "SUSERUNAME" //  第三方用户的ID
private let S_USER_SEXPIRES = "SUSERSEXPIRES" //  第三方用户的SEXPIRES
private let S_USER_AVATAR = "SUSERAVATAR" //  第三方用户的头像
private let S_USER_GENDER = "SUSERGENDER" //  第三方用户的性别

/// 登录用户
public class ShareLUser:NSObject{
    
    /// 用户平台注释
    /// 1 OS
    /// 2 安卓
    /// 3 网页
    /// 4 无法识别
    static var platform:Int = 1
    
    /// 用户是否登陆
    public class var islogin:Bool{
        get{return NSUserDefaults.standardUserDefaults().boolForKey(USER_ISLOGIN) }
        set(new){ NSUserDefaults.standardUserDefaults().setBool(new, forKey: USER_ISLOGIN)}
    }
    
    /// 用户ID
    public class var uid:Int{
        get{return NSUserDefaults.standardUserDefaults().integerForKey(USER_UID) }
        set(new){ NSUserDefaults.standardUserDefaults().setInteger(new, forKey: USER_UID)}
    }
    
    ///  用户类型
    ///  1 本地注册用户 游客用户
    ///  2 游客用户
    ///  3 微博三方用户
    ///  4 微信三方用户
    public class var utype:Int{
        get{return NSUserDefaults.standardUserDefaults().integerForKey(USER_TYPE) }
        set(new){ NSUserDefaults.standardUserDefaults().setInteger(new, forKey: USER_TYPE)}
    }
    
    /// 用户的密码
    class var password:String{
        get{return NSUserDefaults.standardUserDefaults().stringForKey(USER_PASSWORD) ?? ""}
        set(new){ NSUserDefaults.standardUserDefaults().setObject(new, forKey: USER_PASSWORD)}
    }
    
    /// 用户的名称
    public class var uname:String{
        get{return NSUserDefaults.standardUserDefaults().stringForKey(USER_NAME) ?? ""}
        set(new){ NSUserDefaults.standardUserDefaults().setObject(new, forKey: USER_NAME)}
    }
    
    /// 用户的头像
    public class var avatar:String{
        get{return NSUserDefaults.standardUserDefaults().stringForKey(USER_AVATAR) ?? ""}
        set(new){ NSUserDefaults.standardUserDefaults().setObject(new, forKey: USER_AVATAR)}
    }
    
    /// 用户的 Token
    public class var token:String?{
        get{return NSUserDefaults.standardUserDefaults().stringForKey(USER_TOKEN)}
        set(new){ NSUserDefaults.standardUserDefaults().setObject(new, forKey: USER_TOKEN)}
    }
    
    
    /// 第三方用户的id
    public class var s_uid:String{
        get{return NSUserDefaults.standardUserDefaults().stringForKey(S_USER_UID) ?? ""}
        set(new){ NSUserDefaults.standardUserDefaults().setObject(new, forKey: S_USER_UID)}
    }
    
    /// 第三方用户的token
    public class var s_token:String{
        get{return NSUserDefaults.standardUserDefaults().stringForKey(S_USER_TOKEN) ?? ""}
        set(new){ NSUserDefaults.standardUserDefaults().setObject(new, forKey: S_USER_TOKEN)}
    }
    
    /// 第三方用户的过期时间
    public class var s_sexpires:String{
        get{return NSUserDefaults.standardUserDefaults().stringForKey(S_USER_SEXPIRES) ?? ""}
        set(new){ NSUserDefaults.standardUserDefaults().setObject(new, forKey: S_USER_SEXPIRES)}
    }
    
    /// 第三方用户的名称
    public class var s_uname:String{
        get{return NSUserDefaults.standardUserDefaults().stringForKey(S_USER_UNAME) ?? ""}
        set(new){ NSUserDefaults.standardUserDefaults().setObject(new, forKey: S_USER_UNAME)}
    }
    /// 第三方用户的头像
    public class var s_avatar:String{
        get{return NSUserDefaults.standardUserDefaults().stringForKey(S_USER_AVATAR) ?? ""}
        set(new){ NSUserDefaults.standardUserDefaults().setObject(new, forKey: S_USER_AVATAR)}
    }
    /// 第三方用户的 性别
    public class var s_gender:Int{
        get{return NSUserDefaults.standardUserDefaults().integerForKey(S_USER_GENDER)}
        set(new){ NSUserDefaults.standardUserDefaults().setInteger(new, forKey: S_USER_GENDER)}
    }
    
    
    // 获得用户的Token
    public class func getSdkUserToken(finish:((token:String)->Void)?){
        
        guard let t = token else{
            
            return ShareLUserRequest.getUserTokenByRequest({ (user) in
                
                finish?(token: user)
            })
        }
        
        finish?(token: t)
    }
    
    /// 用户注销
    public class func LoginOut() {
        
        ShareLUser.utype = 2
        ShareLUser.uname = ""
        ShareLUser.avatar = ""
        ShareLUser.s_uid = ""
        ShareLUser.s_token = ""
        ShareLUser.s_sexpires = ""
        ShareLUser.s_uname = ""
        ShareLUser.s_avatar = ""
        ShareLUser.s_gender = 0
        
        NSNotificationCenter.defaultCenter().postNotificationName(USERLOGINCHANGENOTIFITION, object: nil)
    }
    
    public class func sprint(){
    
        print("platform:",ShareLUser.platform)
        print("islogin:",ShareLUser.islogin)
        print("uid:",ShareLUser.uid)
        print("utype:",ShareLUser.utype)
        print("uname:",ShareLUser.uname)
        print("avatar:",ShareLUser.avatar)
        print("token:",ShareLUser.token)
        print("s_uid:",ShareLUser.s_uid)
        print("s_token:",ShareLUser.s_token)
        print("s_sexpires:",ShareLUser.s_sexpires)
        print("s_uname:",ShareLUser.s_uname)
        print("s_avatar:",ShareLUser.s_avatar)
        print("s_gender:",ShareLUser.s_gender)
    }
}


public class ShareLUserRequest: NSObject {
    
    /**
     想服务器注册一个游客用户用来完成一些基本到操作
     
     - parameter finish: 完成回调
     - parameter fail:   失败回调
     */
    public class func getUserTokenByRequest(finish:((token:String)->Void),fail:(()->Void)?=nil){
        
        let requestBuder = UserAPI.auSinGPostWithRequestBuilder(userRegisterInfo: VisitorsRegister(utype: 2, platform: 1))
        
        requestBuder.execute { (response, error) in
            
            guard let token =  response?.header["Authorization"],let data = response?.body.objectForKey("data"),uid = data.objectForKey("uid") as? Int,utype = data.objectForKey("utype") as? Int,password = data.objectForKey("password") as? String else{
                fail?()
                return
            }
            
            ShareLUser.islogin = true
            ShareLUser.uid = uid
            ShareLUser.utype = utype
            ShareLUser.password = password
            ShareLUser.token = token
            
            finish(token: token)
        }
    }
    
    /**
     第三方用户注册
     
     - parameter user:   需要完善的用户信息 #UserRegister#
     - parameter finish: 完成 接口 毁掉
     - parameter fail:   失败的 接口回调
     */
    public class func resigterSanFangUser(user:UserRegister,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        let requestBuder = UserAPI.auSinSPostWithRequestBuilder(userRegisterInfo: user)
        requestBuder.execute { (response, error) in
            
            guard let token =  response?.header["Authorization"],let data = response?.body.objectForKey("data"),uid = data.objectForKey("uid") as? Int,utype = data.objectForKey("utype") as? Int else{
                fail?()
                return
            }
            
            if let value = response?.body.objectForKey("uname") as? String{
                ShareLUser.uname = value
            }
            
            if let value = response?.body.objectForKey("avatar") as? String{
                ShareLUser.avatar = value
            }
            
            ShareLUser.uid = uid
            ShareLUser.utype = utype
            ShareLUser.token = token
            
            NSNotificationCenter.defaultCenter().postNotificationName(USERLOGINCHANGENOTIFITION, object: nil)
            
            finish?()
        }
    }
    
    /**
     重新登录方法，在用户使用某些借口的时候，出现了 4003 的回复的时候，说明用户的token 过期。
     需要重新登录
     
     - parameter finish: 完成接口回调
     */
    public class func resetLogin(finish:(()->Void)?=nil){
    
        if ShareLUser.utype == 2 {
            
            let visutor = VisitorsLogin(uid: Int32(ShareLUser.uid), password: ShareLUser.password)
            let requestBuder = UserAPI.auLinGPostWithRequestBuilder(userLoginInfo: visutor)
            
            requestBuder.execute({ (response, error) in
                
                guard let token =  response?.header["Authorization"] else{ return }
                ShareLUser.token = token
                finish?()
            })
        }else{
            
            let user = UserRegister(utype: 3)
            let requestBuder = UserAPI.auSinSPostWithRequestBuilder(userRegisterInfo: user)
            requestBuder.execute { (response, error) in
                
                guard let token =  response?.header["Authorization"] else{return }
                ShareLUser.token = token

                finish?()
            }
        }
    }
}

extension VisitorsLogin{
    
    convenience public init(uid: Int32,password: String){
        self.init()
        self.uid = uid
        self.password = password
    }
}


extension VisitorsRegister{
    
    convenience public init(utype: Int32,platform: Int32){
        self.init()
        self.utype = utype
        self.platform = platform
    }
}



extension UserRegister{
    
    convenience public init(utype:Int){
        self.init()
        
        self.muid = Int32(ShareLUser.uid)
        self.utype = Int32(utype)
        self.platform = Int32(ShareLUser.platform)
        self.suid = ShareLUser.s_uid
        self.stoken = ShareLUser.s_token
        self.sexpires = ShareLUser.s_sexpires
        self.uname = ShareLUser.s_uname
        self.avatar = ShareLUser.s_avatar
        self.gender = Int32(ShareLUser.s_gender)
    }
}
