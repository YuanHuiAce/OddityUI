//
//  SourcesBundle.swift
//  Pods
//
//  Created by Mister on 16/8/31.
//
//

import UIKit

extension NSBundle {
    
    /**
     获取 StoryBoard 的 Bundle 对象
     
     - returns: <#return value description#>
     */
    class func OddityBundle() -> NSBundle{
    
        let podBundle = NSBundle(forClass: OddityViewControllerManager.classForCoder())
        
        if let bundleURL = podBundle.URLForResource("OdditBundle", withExtension: "bundle"),bundle = NSBundle(URL: bundleURL)  {
            
            return bundle
        }
        
        return podBundle
    }
}


extension UIImage{

    class func OddityImageByName(name:String) -> UIImage?{
    
        let bundle = NSBundle.OddityBundle()
        
        return UIImage(named: name, inBundle: bundle, compatibleWithTraitCollection: nil)
    }
}

