//
//  AppDelegate.swift
//  Example
//
//  Created by Mister on 16/8/31.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import OddityUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIFont.a_fontModalStyle = -1
        
        ChannelAPI.nsChsGet()
        
        let viewController = OddityViewControllerManager.shareManager.getsChannelsManagerViewController()

        viewController.odditySetting.showAboutOptions = false
        viewController.oddityDelegate = self
        
        window?.rootViewController = viewController
        
        let viewCOntroller = OddityViewControllerManager.shareManager.getsChannelsManagerViewController()
        
        window?.rootViewController?.view.addSubview(viewCOntroller.view)
        
        viewCOntroller.view.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        
        viewCOntroller.view.layer.borderColor = UIColor.red.cgColor
        viewCOntroller.view.layer.borderWidth = 2
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}




extension AppDelegate:OddityUIDelegate {

    
    func clickAboutOptionAction(viewController: UIViewController, urlString: String) {
        
        print(urlString)
    }
    
    func clickHyperlinkAction(viewController: UIViewController, urlString: String) {
        
        print(urlString)
    }
    
    func clickNewContentImageAction(viewController: UIViewController, newContent: NewContent, imgIndex: Int, imgArray: [String]) {
        
        print(imgIndex)
    }
}
