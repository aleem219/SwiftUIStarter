//
//  AppDelegate.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//
// user name : emilys
// password  : emilyspass
import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    
    func keyChainLoad() {
        let (username, password) = KeychainService.load()
        if let username = username, let password = password {
            print("Loaded username: \(username)")
            print("Loaded password: \(password)")
            moveToTabbar()
        } else {
            moveToLogin()
        }
    }

    
    func moveToHome(completion: (() -> Void)? = nil) {
//        if let vc = StoryboardManager.instantiateTabbar() {
//            let navC = UINavigationController(rootViewController: vc)
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                if let window = windowScene.windows.first {
//                    window.rootViewController = navC
//                    window.makeKeyAndVisible()
//                }
//            }
//        }
    }
    
//    func moveToLogin() {
////        if let vc = StoryboardManager.instantiateLoginVC() {
////            let navC = UINavigationController(rootViewController: vc)
////            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
////                if let window = windowScene.windows.first {
////                    window.rootViewController = navC
////                    window.makeKeyAndVisible()
////                }
////            }
////        }
//    }
    
    func moveToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
    
    func moveToTabbar() {
        let tabbarView = TabbarView()
          let hostingController = UIHostingController(rootView: tabbarView)

          if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
             let window = windowScene.windows.first {
              window.rootViewController = hostingController
              window.makeKeyAndVisible()
          }
    }
}

