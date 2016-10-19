//
//  SourcesBundle.swift
//  Pods
//
//  Created by Mister on 16/8/31.
//
//

import UIKit

public extension Bundle {
    
    /**
     获取 StoryBoard 的 Bundle 对象
     
     - returns: <#return value description#>
     */
    public class func OddityBundle() -> Bundle{
    
        let podBundle = Bundle(for: OddityViewControllerManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "OdditBundle", withExtension: "bundle"),let bundle = Bundle(url: bundleURL)  {
            
            return bundle
        }
        
        return podBundle
    }
}


extension UIImage{

    class func OddityImageByName(_ name:String) -> UIImage?{
    
        let bundle = Bundle.OddityBundle()
        
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}

