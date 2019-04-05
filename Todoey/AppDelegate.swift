//
//  AppDelegate.swift
//  Todoey
//
//  Created by lucas on 2019/3/28.
//  Copyright © 2019 Lucas Huang. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //print("Realm檔案位置：\(Realm.Configuration.defaultConfiguration.fileURL)")

        do {
            _ = try Realm()
        } catch  {
            print("初始化 Realm 錯誤,\(error)")
        }
        
        return true
    }
}
