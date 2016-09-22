//
//  NFLViewControllerExtension.swift
//  Pods
//
//  Created by Mister on 16/9/22.
//
//

import UIKit
import RealmSwift

extension Date{
    
    func UnixTimeString() -> String{
        
        return "\(Int64(self.timeIntervalSince1970*1000))"
    }
}

@objc protocol NewslistViewControllerNoLikeDelegate{
    
    /**
     当用户点击不喜欢按钮，出发的delegate
     
     - parameter cell:   不喜欢按钮所在的cell
     - parameter finish: 当用户处理完方法后
     
     - returns: 空
     */
    @objc optional func ClickNoLikeButtonOfUITableViewCell(_ cell:NewBaseTableViewCell,finish:((_ cancel:Bool)->Void)) -> Void
}



import JMGTemplateEngine

class JMGTemplateEngine{
    
    static let shareTemplateEngine:MGTemplateEngine! = {
        
        let templateEngine = MGTemplateEngine()
        
        templateEngine.matcher = ICUTemplateMatcher(templateEngine: templateEngine)
        
        return templateEngine
    }()
}

extension String{
    
    /**
     处理视频文件
     
     - returns: 处理完成的视频文件
     */
    fileprivate func HandleForVideoHtml() -> String{
        
        return self.replaceRegex("(preview.html)", with: "player.html")
            .replaceRegex("(allowfullscreen=\"\")", with: "")
            .replaceRegex("(class=\"video_iframe\")", with: "")
            .replaceRegex("(width=[0-9]+&)", with: "")
            .replaceRegex("(height=[0-9]+&)", with: "")
            .replaceRegex("(height=\"[0-9]+\")", with: "")
            .replaceRegex("(width=\"[0-9]+\")", with: "")
            .replaceRegex("(&?amp;)", with: "")
            .replaceRegex("(auto=0)", with: "")
        //            .replaceRegex("(frameborder=\"[0-9]+\")", with: "")
    }
    
    
}

extension NewContent{
    
    func scroffY(_ y:CGFloat){
        let realm = try! Realm()
        try! realm.write {
            self.scroffY = Double(y)
        }
    }
    
    func getHtmlResourcesString() -> String{
        
        var body = ""
        
        let title = "#title{font-size:\(UIFont.a_font9.pointSize)px;}"
        let subtitle = "#subtitle{font-size:\(UIFont.a_font8.pointSize)px;}"
        let bodysection = "#body_section{font-size:\(UIFont.a_font3.pointSize)px;}"
        
        for conten in self.content{
            
            if let img = conten.img {
                
                var str = "<div class = \"imgDiv\">&img&</div>"
                
                let res = img.grep("_(\\d+)X(\\d+).").captures
                
                if img.hasSuffix(".gif") {
                    
                    str = "<div class = \"imgDiv\">&span&&img&</div>" // 进度条
                }
                
                if res.count > 0 {
                    
                    if img.hasSuffix(".gif") {
                        
                        str = str.replaceRegex("(&span&)",  with: "<div style=\"height:2px;width:\(res[1])px\" class=\"progress img-responsive center-block customProgress\"><div class=\"progress-bar customProgressBar\" role=\"progressbar\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 0%;\"> <span class=\"sr-only\">40% 完成</span> </div> </div>")
                    }
                    
                    str = str.replaceRegex("(&img&)", with: "<img style=\"display: flex; \" data-src=\"\(img)\" w=\(res[1]) h=\(res[2]) class=\"img-responsive center-block\">")
                    
                }else{
                    
                    str = str.replaceRegex("(&img&)", with: "<img style=\"display: flex; \" data-src=\"\(img)\" class=\"img-responsive center-block\">")
                    
                    str = str.replaceRegex("(&span&)", with: "<div style=\"height:2px;\" class=\"progress customProgress\"><div class=\"progress-bar customProgressBar\" role=\"progressbar\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 0%;\"> </div> </div>")
                }
                
                body += str
            }
            
            if let vid = conten.vid {
                
                let str = vid.HandleForVideoHtml()
                
                body += "<div id=\"video\">\(str)</div>"
            }
            
            if let txt = conten.txt {
                
                body += "<p>\(txt)</p>"
            }
        }
        
        let templatePath = Bundle.OddityBundle().path(forResource: "content_template", ofType: "html")
        
        let comment = self.comment > 0 ? "   \(self.comment)评" : ""
        
        let variables = ["title":self.title,"source":self.pname,"ptime":self.ptime,"theme":"normal","body":body,"comment":comment,"titleStyle":title,"subtitleStyle":subtitle,"bodysectionStyle":bodysection]
        
        let result = JMGTemplateEngine.shareTemplateEngine.processTemplateInFile(atPath: templatePath, withVariables: variables)
        
        return result!
    }
}

