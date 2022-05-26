//
//  LoginViewController.swift
//  SocialLoginSample
//
//  Created by HwangByungJo  on 2022/05/26.
//

import UIKit

class LoginViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
    
  @IBAction func onClickGoogleBtn(_ sender: Any) {
    
    LoginManager.shared.loginGoogle(presenting: self) { isSuccess, result in
      if isSuccess {
        self.dismiss(animated: true)
      } else {
        print("Googl Login Error: \(result)")
      }
    }    
  }
  
  @IBAction func onClickAppleBtn(_ sender: Any) {
    
    LoginManager.shared.loginApple() { isSuccess, result in
      if isSuccess {
        self.dismiss(animated: true)
      } else {
        print("Apple Login Error: \(result)")
      }
    }
  }
}
