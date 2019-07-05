//
//  AppDelegate.swift
//  MyFirstApp
//
//  Created by Prithvi on 04/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle")?.load()
        inject {
            self.appLaunched()
        }
        #endif
        appLaunched()
        return true
    }
    
    func appLaunched() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: UIViewController.controller(.login))
        window?.makeKeyAndVisible()
    }
}

