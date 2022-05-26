//
//  AppDelegate.swift
//  SocialLoginSample
//
//  Created by HwangByungJo  on 2022/05/26.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?  
  var mainVC: ViewController?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    FirebaseApp.configure()
            
    FBSDKCoreKit.ApplicationDelegate.shared.application(application,
                                                        didFinishLaunchingWithOptions: launchOptions)
                
    return true
  }
  
  func application(_ app: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
    if url.absoluteString.hasPrefix("fb") {
      return ApplicationDelegate.shared.application(app,
                                                    open: url,
                                                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                    annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    } else {
      return GIDSignIn.sharedInstance.handle(url)
    }
  }
}

