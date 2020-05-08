//
//  AppDelegate.swift
//  RegestrationApp
//
//  Created by ahmedelbasha on 4/29/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//
import IQKeyboardManagerSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let isSignedIn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isSignedIn)
        let isSignedUp = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isSignedUp)
        
        if isSignedUp {
            let SignedIn = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signInVC) as! SignInVC
            let nav = UINavigationController(rootViewController: SignedIn)
            window?.rootViewController = nav
        }else if isSignedIn {
         
            let storyboard = UIStoryboard.init(name: "\(Storyboards.tabBar)", bundle: nil)
            
            // controller identifier sets up in storyboard utilities
            // panel (on the right), it called Storyboard ID
            let viewController = storyboard.instantiateViewController(withIdentifier: "\(VCs.tabVC)") as! tabVC
            
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            
            window?.makeKeyAndVisible()
            window?.rootViewController = viewController
            
        } else {
            let signUpVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signUpVC) as! SignUpVC
            let nav = UINavigationController(rootViewController: signUpVC)
            window?.rootViewController = nav
        }
          IQKeyboardManager.shared.enable = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

